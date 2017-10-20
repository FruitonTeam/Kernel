package test.effects;

import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.effects.*;
import fruiton.kernel.Fruiton.MoveGenerators;
import fruiton.kernel.Fruiton.AttackGenerators;
import fruiton.kernel.targetPatterns.*;
import fruiton.dataStructures.*;

class EffectsTest {

    static var p1:Player = new Player(0);
    static var p2:Player = new Player(1);

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
        Sys.println("=== running lowerAttackOnAttack_attackEnemy_appliesDebuff");
        var targetPos = new Vector2(0, 1);
        var k:Kernel = new Kernel(p1, p2,
        [
            new Fruiton(1, new Vector2(0, 0), p1, 10, 5, "", getMoveGenerators(), getAttackGenerators(),
            [new LowerAttackOnAttackEffect(2)], 1),

            new Fruiton(2, targetPos, p2, 10, 5, "", getMoveGenerators(), getAttackGenerators(), [], 1)
        ]
        );

        var actions:IKernel.Actions = k.getAllValidActions();

        var action:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);

        var result:IKernel.Events = k.performAction(action);

        var event:AddEffectEvent = Hlinq.firstOfTypeOrNull(result, AddEffectEvent);

        Assert.isNotNull(event);
        Assert.isTrue(k.currentState.field.get(targetPos).fruiton.effects[0] != null);
        Assert.isTrue(Std.is(k.currentState.field.get(targetPos).fruiton.effects[0], LoweredAttackEffect));
        Assert.isTrue(
            Std.instance(k.currentState.field.get(targetPos).fruiton.effects[0], LoweredAttackEffect)
            .amount == 2);
    }

    @Test
    public function lowerAttackOnAttack_attack1DmgEnemy_dontApplyDebuff() {
        Sys.println("=== running lowerAttackOnAttack_attack1DmgEnemy_dontApplyDebuff");
        var targetPos = new Vector2(0, 1);
        var k:Kernel = new Kernel(p1, p2,
        [
            new Fruiton(1, new Vector2(0, 0), p1, 10, 5, "", getMoveGenerators(), getAttackGenerators(),
            [new LowerAttackOnAttackEffect(2)], 1),

            new Fruiton(2, targetPos, p2, 10, 1, "", getMoveGenerators(), getAttackGenerators(), [], 1)
        ]
        );

        var actions:IKernel.Actions = k.getAllValidActions();

        var action:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);

        var result:IKernel.Events = k.performAction(action);

        var event:AddEffectEvent = Hlinq.firstOfTypeOrNull(result, AddEffectEvent);

        Assert.isNull(event);
    }

    @Test
    public function loweredAttack_attackEnemy_dealLowerDamage() {
        Sys.println("=== loweredAttack_attackEnemy_dealLowerDamage");
        var k:Kernel = new Kernel(p1, p2,
        [
            new Fruiton(1, new Vector2(0, 0), p1, 10, 5, "", getMoveGenerators(), getAttackGenerators(),
            [new LoweredAttackEffect(3)], 1),

            new Fruiton(2, new Vector2(0, 1), p2, 10, 5, "", getMoveGenerators(), getAttackGenerators(), [], 1)
        ]
        );
        k.startGame();
        var actions:IKernel.Actions = k.getAllValidActions();
        var action:AttackAction = Hlinq.firstOfTypeOrNull(actions, AttackAction);
        var result:IKernel.Events = k.performAction(action);

        var event:AttackEvent = Hlinq.firstOfTypeOrNull(result, AttackEvent);
        Assert.isNotNull(event);
        Assert.isTrue(event.damage == 2);
    }
}