package test.movement;

import massive.munit.util.Timer;
import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.Fruiton.MoveGenerators;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.targetPatterns.*;
import fruiton.kernel.exceptions.InvalidActionException;
import fruiton.dataStructures.*;
import fruiton.kernel.Tile.TileType;

class BasicMoveTest {

    var timer:Timer;

    public function new() {
    }

    @BeforeClass
    public function beforeClass() {
        Sys.println("====================");
        Sys.println("Basic movement tests");
        Sys.println("====================");
    }

    @AfterClass
    public function afterClass() {}

    @Before
    public function setup() {}

    @After
    public function tearDown() {}

    function makeKernel(?withObstacles:Bool = false):Kernel {
        var p1:Player = new Player(1);
        var p2:Player = new Player(2);
        var moveGenerators:MoveGenerators = new MoveGenerators();
        moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(0, 1), -1, 1)));
        moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1)));
        var attributes:FruitonAttributes = new FruitonAttributes(10, 0);
        var fruiton:Fruiton = new Fruiton(1, 1, "", new Vector2(0, 1), p1, "Apple_red", moveGenerators, [], [], 1, attributes);

        var settings:GameSettings = GameSettings.createDefault();
        if (withObstacles) {
            settings.map[0][2] = TileType.impassable;
            settings.map[0][0] = TileType.impassable;
        }

        return new Kernel(p1, p2, [fruiton], settings);
    }

    function makeKernelWithOverlappingMovement():Kernel {
        var p1:Player = new Player(1);
        var p2:Player = new Player(2);
        var moveGenerators:MoveGenerators = new MoveGenerators();
        moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(0, 1), -1, 1)));
        moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1)));
        moveGenerators.push(new MoveGenerator(new RangeTargetPattern(Vector2.ZERO, 0, 2)));
        var attributes:FruitonAttributes = new FruitonAttributes(10, 0);
        var fruiton:Fruiton = new Fruiton(1, 1, "", new Vector2(0, 1), p1, "Apple_red", moveGenerators, [], [], 1, attributes);
        return new Kernel(p1, p2, [fruiton], GameSettings.createDefault());
    }

    @Test
    public function performAction_invalidAction_throwsInvalidActionException() {
        Sys.println("=== running performAction_invalidAction_throwsInvalidActionException");
        try {
            var kernel:IKernel = makeKernel();
            var a:Action = new MoveAction(new MoveActionContext(null, null));
            kernel.performAction(a);
        } catch (e : InvalidActionException) {
            // Expected behavior
            return;
        }

        Assert.isTrue(false);
    }

    @Test
    public function performAction_nullAction_throwsInvalidActionException() {
        Sys.println("=== running performAction_nullAction_throwsInvalidActionException");
        try {
            var kernel:IKernel = makeKernel();
            kernel.performAction(null);
        } catch (e : InvalidActionException) {
            // Expected behavior
            return;
        }

        Assert.isTrue(false);
    }

    @Test
    public function getAllValidActions_validKernel_returnsAtLeastOneMoveAction() {
        Sys.println("=== running getAllValidActions_validKernel_returnsAtLeastOneMoveAction");

        var k:Kernel = makeKernel();
        var actions:IKernel.Actions = k.getAllValidActions();
        var moveAction:MoveAction = Hlinq.firstOfTypeOrNull(actions, MoveAction);

        Assert.isTrue(moveAction != null);
    }

    @Test
    public function getAllValidActions_overlappingMoves_doesNotReturnDuplicateActions() {
        Sys.println("=== running getAllValidActions_overlappingMoves_doesNotReturnDuplicateActions");

        var k:Kernel = makeKernelWithOverlappingMovement();
        var actions:IKernel.Actions = k.getAllValidActions();

        for (i in 0...actions.length) {
            for (j in (i + 1)...actions.length) {
                Assert.isFalse(actions[i].equalsTo(actions[j]));
            }
        }
    }

    @Test
    public function performAction_validMoveAction_returnsMatchingEvent() {
        Sys.println("=== running performAction_validMoveAction_returnsMatchingEvent");

        var k:Kernel = makeKernel();
        var actions:IKernel.Actions = k.getAllValidActions();
        var action:MoveAction = Hlinq.firstOfTypeOrNull(actions, MoveAction);

        var result:IKernel.Events = k.performAction(action);
        var event:MoveEvent = Hlinq.firstOfTypeOrNull(result, MoveEvent);

        Assert.isTrue(event != null);
        Assert.isTrue(action.actionContext.source == event.from);
        Assert.isTrue(action.actionContext.target == event.to);
    }

    @Test
    public function getAllActionsFrom_kernelWithOneFruiton_returnsAllActions() {
        Sys.println("=== running getAllActionsFrom_kernelWithOneFruiton_returnsAllActions");

        var k:Kernel = makeKernel();
        var allActions:IKernel.Actions = k.getAllValidActions();
        var allActionsFrom:IKernel.Actions = k.getAllValidActionsFrom(k.currentState.fruitons[0].position);

        Assert.isTrue(allActions.length == allActionsFrom.length);
    }

    @Test
    public function getAllActions_mapWithObstacles_doesNotReturnBlocked() {
        Sys.println("=== running getAllActions_mapWithObstacles_doesNotReturnBlocked");

        var k:Kernel = makeKernel(true);
        var allActions:IKernel.Actions = k.getAllValidActions();
        var action:MoveAction = Hlinq.singleOfTypeOrNull(allActions, MoveAction);

        Assert.isTrue(action.actionContext.target.x == 1 && action.actionContext.target.y == 1);
    }

    @Test
    public function performAction_toBlockedPosition_throwsInvalidActionException() {
        Sys.println("=== running performAction_toBlockedPosition_throwsInvalidActionException");
        try {
            var kernel:Kernel = makeKernel(true);
            var a:Action = new MoveAction(new MoveActionContext(kernel.currentState.fruitons[0].position, new Vector2(0, 0)));
            kernel.performAction(a);
        } catch (e : InvalidActionException) {
            // Expected behavior
            return;
        }

        Assert.isTrue(false);
    }

    function printField(field:Field) {
        for (x in 0...GameState.WIDTH) {
            var line:String = "";
            for (y in 0...GameState.HEIGHT) {
                var fruiton:Fruiton = field.get(new Vector2(x, y)).fruiton;
                if (fruiton == null) {
                    line += " . ";
                }
                else {
                    line += " " + fruiton.id + " ";
                }
            }
            Sys.println(line);
        }
    }
}
