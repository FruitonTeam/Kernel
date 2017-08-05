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

	function makeKernel():Kernel {
		var p1:Player = new Player(1);
		var p2:Player = new Player(2);
		var moveGenerators:MoveGenerators = new MoveGenerators();
		moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(0, 1), -1, 1)));
		moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1)));
		var fruiton:Fruiton = new Fruiton(1, new Vector2(0, 1), p1, moveGenerators);
		return new Kernel(p1, p2, [fruiton]);
	}

    @Test
    public function performAction_invalidAction_throwsInvalidActionException() {
        Sys.println("=== running performAction_invalidAction_throwsInvalidActionException");
        try {
			var kernel:IKernel = makeKernel();
			var a:Action = new MoveAction(new MoveActionContext(null, null));
			kernel.performAction(a);
		}
		catch (e : InvalidActionException) {
			// Expected behavior
		}
    }

	@Test
	public function performAction_nullAction_throwsInvalidActionException() {
        Sys.println("=== running performAction_nullAction_throwsInvalidActionException");
		try {
			var kernel:IKernel = makeKernel();
			kernel.performAction(null);
		}
		catch (e : InvalidActionException) {
			// Expected behavior
		}
	}

	@Test
	public function getAllValidActions_validKernel_returnsAtLeastOneMoveAction() {
		Sys.println("=== running getAllValidActions_validKernel_returnsAtLeastOneMoveAction");

		var k:Kernel = makeKernel();
		var actions:IKernel.Actions = k.getAllValidActions();

		var hasMoveAction:Bool = false;
		for (a in actions) {
			if (Std.is(a, MoveAction)) {
				hasMoveAction = true;
				break;
			}
		}
		Assert.isTrue(hasMoveAction);
	}

	@Test
	public function performAction_validMoveAction_returnsMatchingEvent() {
		Sys.println("=== running performAction_validMoveAction_returnsMatchingEvent");

		var k:Kernel = makeKernel();
		var actions:IKernel.Actions = k.getAllValidActions();

		var action:MoveAction = null;
		for (a in actions) {
			if (Std.is(a, MoveAction)) {
				action = cast(a, MoveAction);
				break;
			}
		}

		var result:IKernel.Events = k.performAction(action);
		var event:MoveEvent = null;
		for (e in result) {
			if (Std.is(e, MoveEvent)) {
				event = cast(e, MoveEvent);
				break;
			}
		}

		Assert.isTrue(event != null);
		Assert.isTrue(action.actionContext.source == event.from);
		Assert.isTrue(action.actionContext.target == event.to);
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
