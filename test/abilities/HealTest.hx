package test.abilities;

import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.Fruiton.MoveGenerators;
import fruiton.kernel.Fruiton.AttackGenerators;
import fruiton.kernel.targetPatterns.*;
import fruiton.dataStructures.*;
import fruiton.kernel.abilities.HealAbility;

class HealTest {

	public function new() {}

	@BeforeClass
	public function beforeClass() {
		Sys.println("============");
		Sys.println("Heal tests");
		Sys.println("============");
	}

	/**
     * Factory method for unified and simple kernel creation
     * @return Kernel which is initialized
     */
	public static function makeKernel(damage:Int):Kernel {
		var p1:Player = new Player(0);
		var p2:Player = new Player(1);

		var hp:Int = 10;
		var attack:Int = 2;
        var heal:Int = 5;

		var moveGenerators:MoveGenerators = new MoveGenerators();
		moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(0, 1), -1, 1)));
		moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1)));


		var attackGenerators:AttackGenerators = new AttackGenerators();
		attackGenerators.push(new AttackGenerator(new RangeTargetPattern(Vector2.ZERO, 0, 1)));
		attackGenerators.push(new AttackGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1)));

		var originalAttributes:FruitonAttributes = new FruitonAttributes(hp, attack, heal);
        var currentAttributes:FruitonAttributes = new FruitonAttributes(hp - damage, attack, heal);
        var abilities:Fruiton.Abilities = new Fruiton.Abilities();
        abilities.push(new HealAbility(new RangeTargetPattern(Vector2.ZERO, 0, 10)));
		var fruiton:Fruiton = new Fruiton(1, 1, "", new Vector2(0, 0), p1, "", moveGenerators, attackGenerators, [], 1, originalAttributes, currentAttributes, abilities);
		var fruiton2:Fruiton = new Fruiton(2, 2, "", new Vector2(0, 1), p1, "", moveGenerators, attackGenerators, [], 1, originalAttributes, currentAttributes);
        var fruiton3:Fruiton = new Fruiton(2, 2, "", new Vector2(0, 2), p2, "", moveGenerators, attackGenerators, [], 1, originalAttributes, currentAttributes);
		return new Kernel(p1, p2, [fruiton, fruiton2], GameSettings.createDefault());
	}

	@Test
	public function performHealAction_healFriendly_increaseHp() {
		Sys.println("=== running performHealAction_healFriendly_increaseHp");

		var k:Kernel = makeKernel(6);
		var actions:IKernel.Actions = k.getAllValidActions();

		var action:HealAction = Hlinq.firstOfTypeOrNull(actions, HealAction);
		var result:IKernel.Events = k.performAction(action);
		var event:HealEvent = Hlinq.firstOfTypeOrNull(result, HealEvent);
        var healedFruiton:Fruiton = k.currentState.field.get(event.target).fruiton;
        var healingFruiton:Fruiton = k.currentState.field.get(event.source).fruiton;
        Assert.isTrue(event.heal == 5);
        Assert.isTrue(healedFruiton.currentAttributes.hp == 9);
        Assert.isTrue(healedFruiton.owner == healingFruiton.owner);
	}

    @Test
	public function performHealAction_overhealFriendly_increaseHp() {
		Sys.println("=== running performHealAction_overhealFriendly_increaseHp");

		var k:Kernel = makeKernel(1);
		var actions:IKernel.Actions = k.getAllValidActions();

		var action:HealAction = Hlinq.firstOfTypeOrNull(actions, HealAction);
		var result:IKernel.Events = k.performAction(action);
		var event:HealEvent = Hlinq.firstOfTypeOrNull(result, HealEvent);
        var healedFruiton:Fruiton = k.currentState.field.get(event.target).fruiton;
        var healingFruiton:Fruiton = k.currentState.field.get(event.source).fruiton;
        Assert.isTrue(event.heal == 5);
        Assert.isTrue(healedFruiton.currentAttributes.hp == 10);
        Assert.isTrue(healedFruiton.owner == healingFruiton.owner);
	}

}