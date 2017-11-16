package test.gameRules;

import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.Fruiton.MoveGenerators;
import fruiton.kernel.Fruiton.AttackGenerators;
import fruiton.kernel.targetPatterns.*;
import fruiton.dataStructures.*;

class GameRulesTest {

    public function new() {
    }

    @BeforeClass
    public function beforeClass() {
        Sys.println("================");
        Sys.println("Game rules tests");
        Sys.println("================");
    }

    /**
     * Factory method for unified and simple kernel creation
     * @return Kernel which is initialized
     */
    function makeKernel(kill:Bool, ?timeLimit:Float = 999):Kernel {
		var p1:Player = new Player(0);
		var p2:Player = new Player(1);

        var hp:Int = 10;
        var dmg:Int = kill ? hp : hp - 1;

        var moveGenerators:MoveGenerators = new MoveGenerators();
        moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(0, 1), -1, 1)));
        moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1)));

        var attackGenerators:AttackGenerators = new AttackGenerators();
        attackGenerators.push(new AttackGenerator(new RangeTargetPattern(Vector2.ZERO, 0, 1)));
        attackGenerators.push(new AttackGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1)));

        var attributes:FruitonAttributes = new FruitonAttributes(hp, dmg);
        var fruiton:Fruiton = new Fruiton(1, new Vector2(0, 0), p1, "", moveGenerators, attackGenerators, [], Fruiton.KING_TYPE, attributes);
        var fruiton1:Fruiton = new Fruiton(2, new Vector2(1, 1), p1, "", moveGenerators, attackGenerators, [], Fruiton.MINOR_TYPE, attributes);
        var fruiton2:Fruiton = new Fruiton(3, new Vector2(0, 1), p2, "", moveGenerators, attackGenerators, [], Fruiton.KING_TYPE, attributes);
        Kernel.turnTimeLimit = timeLimit;
		return new Kernel(p1, p2, [fruiton, fruiton1, fruiton2]);
	}

    @Test
    function performAction_killKingFruiton_returnsGameOver() {
        Sys.println("=== running performAction_killKingFruiton_returnsGameOver");

        var k:Kernel = makeKernel(true);
		var actions:IKernel.Actions = k.getAllValidActions();
		var attackAction:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);
        var events = k.performAction(attackAction);

        var gameOver = Hlinq.singleOfTypeOrNull(events, GameOverEvent);
        Assert.isTrue(gameOver != null);
    }

    @Test
    function performAction_killKingFruiton_returnsCorrectLoser() {
        Sys.println("=== running performAction_killKingFruiton_returnsCorrectLoser");

        var k:Kernel = makeKernel(true);
		var actions:IKernel.Actions = k.getAllValidActions();
		var attackAction:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);
        var events = k.performAction(attackAction);

        var gameOver = Hlinq.singleOfTypeOrNull(events, GameOverEvent);
        Assert.isTrue(gameOver.losers.length == 1);
        Assert.isTrue(gameOver.losers[0] == k.currentState.otherPlayer.id);
    }

    @Test
    function getAllValidActions_afterMoveAction_returnsActionsOnlyForMoved() {
        Sys.println("=== running getAllValidActions_afterMoveAction_returnsActionsOnlyForMoved");

        var k:Kernel = makeKernel(true);
        var actionsBefore = k.getAllValidActionsFrom(new Vector2(1, 1));
        var attackBefore = Hlinq.firstOfTypeOrNull(actionsBefore, AttackAction);

        var result = k.performAction(new MoveAction(new MoveActionContext(new Vector2(0, 0), new Vector2(1, 0))));

        var actionsAfter = k.getAllValidActionsFrom(new Vector2(1, 1));
        var attackAfter = Hlinq.firstOfTypeOrNull(actionsAfter, AttackAction);
        Assert.isTrue(attackBefore != null);
        Assert.isTrue(attackAfter == null);
    }

    @Test
    function performAction_actionAfterTimeout_returnsTimeExpiredEvent() {
        Sys.println("=== running performAction_actionAfterTimeout_returnsTimeExpiredEvent");

        var k:Kernel = makeKernel(true, 0.1);
        var actions = k.getAllValidActionsFrom(new Vector2(1, 1));
        var attackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);

        Sys.sleep(Kernel.turnTimeLimit * 2);

        var result = k.performAction(attackAction);
        var timeExpiredEvent = Hlinq.singleOfTypeOrNull(result, TimeExpiredEvent);

        Assert.isTrue(result.length == 1);
        Assert.isTrue(timeExpiredEvent != null);
    }

    @Test
    function startGame_byDefault_resetsTimer() {
        Sys.println("=== running startGame_byDefault_resetsTimer");

        var k:Kernel = makeKernel(true, 0.1);

        Sys.sleep(Kernel.turnTimeLimit * 2);

        k.startGame();
        var actions = k.getAllValidActionsFrom(new Vector2(1, 1));
        var attackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);

        var result = k.performAction(attackAction);
        var timeExpiredEvent = Hlinq.singleOfTypeOrNull(result, TimeExpiredEvent);

        Assert.isTrue(timeExpiredEvent == null);
    }
}
