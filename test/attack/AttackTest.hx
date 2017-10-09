package test.attack;

import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.Fruiton.MoveGenerators;
import fruiton.kernel.Fruiton.AttackGenerators;
import fruiton.kernel.targetPatterns.*;
import fruiton.dataStructures.*;

class AttackTest {

    public function new() {}

    @BeforeClass
	public function beforeClass() {
		Sys.println("============");
        Sys.println("Attack tests");
        Sys.println("============");
	}

    /**
     * Factory method for unified and simple kernel creation
     * @return Kernel which is initialized
     */
    function makeKernel(kill:Bool):Kernel {
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

        var fruiton:Fruiton = new Fruiton(1, new Vector2(0, 0), p1, hp, dmg, "", moveGenerators, attackGenerators, 1);
        var fruiton2:Fruiton = new Fruiton(2, new Vector2(0, 1), p2, hp, dmg, "", moveGenerators, attackGenerators, 1);
		return new Kernel(p1, p2, [fruiton, fruiton2]);
	}

    @Test
    public function getAllValidActions_fruitonsInRange_returnsOneAttackAction() {
        Sys.println("=== running getAllValidActions_fruitonsInRange_returnsOneAttackAction");

		var k:Kernel = makeKernel(true);
		var actions:IKernel.Actions = k.getAllValidActions();
		var attackAction:AttackAction = Hlinq.singleOfTypeOrNull(actions, AttackAction);

		Assert.isTrue(attackAction != null);
    }

    @Test
	public function performAction_validAttackAction_returnsMatchingEvent() {
		Sys.println("=== running performAction_validAttackAction_returnsMatchingEvent");

		var k:Kernel = makeKernel(true);
		var actions:IKernel.Actions = k.getAllValidActions();
		var action:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);

		var result:IKernel.Events = k.performAction(action);
		var event:AttackEvent = Hlinq.firstOfTypeOrNull(result, AttackEvent);

		Assert.isTrue(event != null);
		Assert.isTrue(action.actionContext.source == event.source);
		Assert.isTrue(action.actionContext.target == event.target);
        Assert.isTrue(action.actionContext.damage == event.damage);
	}

    @Test
	public function performAction_attackKill_returnsDeathEvent() {
		Sys.println("=== running performAction_attackKill_returnsDeathEvent");

		var k:Kernel = makeKernel(true);
		var actions:IKernel.Actions = k.getAllValidActions();
		var action:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);

		var result:IKernel.Events = k.performAction(action);
		var event:DeathEvent = Hlinq.firstOfTypeOrNull(result, DeathEvent);

		Assert.isTrue(event != null);
		Assert.isTrue(action.actionContext.target == event.target);
	}

    @Test
	public function performAction_attackNoKill_lowersFruitonHealth() {
		Sys.println("=== running performAction_attackNoKill_lowersFruitonHealth");

		var k:Kernel = makeKernel(false);
		var actions:IKernel.Actions = k.getAllValidActions();
		var action:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);

        var hpBefore:Int = k.currentState.field.get(action.actionContext.target).fruiton.hp;

		k.performAction(action);

        var hpAfter:Int = k.currentState.field.get(action.actionContext.target).fruiton.hp;

		Assert.isTrue(hpBefore - hpAfter == action.actionContext.damage);
	}

	@Test
    public function getAllActions_afterAttackPerformed_returnsOnlyEndTurn() {
		Sys.println("=== running getAllActions_afterMovePerformed_returnsOnlyEndTurn");

		var k:Kernel = makeKernel(false);
		var actions = k.getAllValidActions();
		var action:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);
		k.performAction(action);

		actions = k.getAllValidActions();
		var endTurnAction = Hlinq.firstOfTypeOrNull(actions, EndTurnAction);
		Assert.isTrue(endTurnAction != null);
    }
}
