package test.attack;

import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.effects.LoweredAttackEffect;
import fruiton.kernel.effects.LowerAttackOnAttackEffect;
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
    public static function makeKernel(kill:Bool):Kernel {
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

        var fruiton:Fruiton = new Fruiton(1, new Vector2(0, 0), p1, hp, dmg, "", moveGenerators, attackGenerators, [new LowerAttackOnAttackEffect(30)], 1);
        var fruiton2:Fruiton = new Fruiton(2, new Vector2(0, 1), p2, hp, dmg, "", moveGenerators, attackGenerators, [new LowerAttackOnAttackEffect(30)], 1);
		return new Kernel(p1, p2, [fruiton, fruiton2]);
	}

    @Test
	public function performAction_validAttackAction_returnsMatchingEvent() {
		Sys.println("=== running performAction_validAttackAction_returnsMatchingEvent");

		var k:Kernel = makeKernel(false);
		var actions:IKernel.Actions = k.getAllValidActions();
		var action:Action = Hlinq.firstOfTypeOrNull(actions, AttackAction);

		Sys.println("1******************************************************************************");
		var result:IKernel.Events = k.performAction(action);
		Sys.println("2******************************************************************************");
		action = Hlinq.firstOfTypeOrNull(k.getAllValidActions(), EndTurnAction);
		Sys.println("3******************************************************************************");
		result = k.performAction(action);
		Sys.println("4******************************************************************************");
		action = Hlinq.firstOfTypeOrNull(k.getAllValidActions(), AttackAction);
		Sys.println("5******************************************************************************");
		result = k.performAction(action);
	}
}
