package test.effects;

import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.effects.*;
import fruiton.kernel.effects.contexts.*;
import fruiton.kernel.effects.triggers.*;
import fruiton.kernel.Fruiton.MoveGenerators;
import fruiton.kernel.Fruiton.AttackGenerators;
import fruiton.kernel.targetPatterns.*;
import fruiton.dataStructures.*;
import fruiton.kernel.abilities.HealAbility;

class EffectsTest {

    static var p1:Player = new Player(0);
    static var p2:Player = new Player(1);
    static var targetPatternItselfOnly:RangeTargetPattern = new RangeTargetPattern(new Vector2(0, 0), 0, 0);

    public function new() {}

    @BeforeClass
    public function beforeClass() {
        Sys.println("=============");
        Sys.println("Effects tests");
        Sys.println("=============");
    }


    public static function getMoveGenerators():MoveGenerators {
        var moveGenerators:MoveGenerators = new MoveGenerators();
        moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(0, 1), -1, 1)));
        moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1)));
        return moveGenerators;
    }

    public static function getAttackGenerators():AttackGenerators {
        var attackGenerators:AttackGenerators = new AttackGenerators();
        attackGenerators.push(new AttackGenerator(new RangeTargetPattern(Vector2.ZERO, 0, 1)));
        attackGenerators.push(new AttackGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1)));
        return attackGenerators;
    }

    @Test
    public function lowerAttackOnAttack_attackEnemy_createsEventAppliesDebuff() {
        Sys.println("=== running lowerAttackOnAttack_attackEnemy_createsEventAppliesDebuff");
        var targetPos = new Vector2(0, 1);
        var attributes:FruitonAttributes = new FruitonAttributes(10, 5);
        var innerEffect = new LoweredAttackEffect(1, 2);

        var k:Kernel = new Kernel(p1, p2,
        [
            new Fruiton(1, 1, "", new Vector2(0, 0), p1, "", getMoveGenerators(), getAttackGenerators(),
            [new OnAttackTrigger(1, innerEffect, targetPatternItselfOnly)], 1, attributes),

            new Fruiton(2, 2, "", targetPos, p2, "", getMoveGenerators(), getAttackGenerators(), [], 1, attributes)
        ]
        , GameSettings.createDefault()
        );

        var actions:IKernel.Actions = k.getAllValidActions();

        var action:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);

        var result:IKernel.Events = k.performAction(action);

        var event:ModifyAttackEvent = Hlinq.firstOfTypeOrNull(result, ModifyAttackEvent);

        var effect:Effect = k.currentState.field.get(targetPos).fruiton.effects[0];
        Assert.isNotNull(event);
        Assert.isTrue(effect != null);
        Assert.isTrue(Std.is(effect, LoweredAttackEffect));
        Assert.isTrue(
            Std.instance(effect, LoweredAttackEffect)
            .amount == 2);
    }

    @Test
    public function lowerAttackOnAttack_attack1DmgEnemy_dontApplyDebuff() {
        Sys.println("=== running lowerAttackOnAttack_attack1DmgEnemy_dontApplyDebuff");
        var targetPos = new Vector2(0, 1);
        var attributes1:FruitonAttributes = new FruitonAttributes(10, 5);
        var attributes2:FruitonAttributes = new FruitonAttributes(10, 1);
        var innerEffect = new LoweredAttackEffect(1, 2);
        var k:Kernel = new Kernel(p1, p2,
        [
            new Fruiton(1, 1, "", new Vector2(0, 0), p1, "", getMoveGenerators(), getAttackGenerators(),
            [new OnAttackTrigger(1, innerEffect, targetPatternItselfOnly)], 1, attributes1),

            new Fruiton(2, 2, "", targetPos, p2, "", getMoveGenerators(), getAttackGenerators(), [], 1, attributes2)
        ]
        , GameSettings.createDefault()
        );
        var actions:IKernel.Actions = k.getAllValidActions();

        var action:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);

        var result:IKernel.Events = k.performAction(action);

        var event:ModifyAttackEvent = Hlinq.firstOfTypeOrNull(result, ModifyAttackEvent);

        Assert.isNull(event);
    }

    @Test
    public function immunityEffect_addAndTest_healingDisabled() {
        Sys.println("=== immunityEffect_addAndTest_healingDisabled");
        var attributes1:FruitonAttributes = new FruitonAttributes(10, 5);
        var attributes2:FruitonAttributes = new FruitonAttributes(10, 1, 3);
        var k:Kernel = new Kernel(p1, p2,
        [
            new Fruiton(1, 1, "", new Vector2(0, 0), p1, "", getMoveGenerators(), getAttackGenerators(),
            [new OnAttackTrigger(1, new ImmunityEffect(1, 3), new RangeTargetPattern(Vector2.ZERO, 0, 0))], 1, attributes1),

            new Fruiton(2, 2, "", new Vector2(0, 1), p2, "", getMoveGenerators(), getAttackGenerators(), [], 1, attributes2)
        ]
        , GameSettings.createDefault()
        );
        var actions:IKernel.Actions = k.getAllValidActions();
        var action:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);
        var result:IKernel.Events = k.performAction(action);

        var healAction:HealAction = Hlinq.firstOfTypeOrNull(actions,HealAction);
        Assert.isNull(healAction);
    }

        @Test
    public function loweredAttack_attackEnemy_dealLowerDamage() {
        Sys.println("=== loweredAttack_attackEnemy_dealLowerDamage");
        var attributes1:FruitonAttributes = new FruitonAttributes(10, 5);
        var attributes2:FruitonAttributes = new FruitonAttributes(10, 1);
        var abilities:Fruiton.Abilities = new Fruiton.Abilities();
        abilities.push(new HealAbility(new RangeTargetPattern(Vector2.ZERO, 0, 10)));
        var k:Kernel = new Kernel(p1, p2,
        [
            new Fruiton(1, 1, "", new Vector2(0, 0), p1, "", getMoveGenerators(), getAttackGenerators(),
            [new LoweredAttackEffect(1, 3)], 1, attributes1),

            new Fruiton(2, 2, "", new Vector2(0, 1), p2, "", getMoveGenerators(), getAttackGenerators(), [], 1, attributes2, abilities)
        ]
        , GameSettings.createDefault()
        );
        var actions:IKernel.Actions = k.getAllValidActions();
        var action:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);
        var result:IKernel.Events = k.performAction(action);

        var event:AttackEvent = Hlinq.firstOfTypeOrNull(result, AttackEvent);
        Assert.isNotNull(event);
        Assert.isTrue(event.damage == 2);
    }
}