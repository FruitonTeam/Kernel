package fruiton.kernel.effects.triggers;

import fruiton.kernel.actions.AttackActionContext;
import fruiton.kernel.targetPatterns.TargetPattern;

class OnAttackTrigger extends TargetableTrigger {

    public function new(fruitonId:Int, effect:Effect, targetPattern:TargetPattern, text:String = "") {
        super(fruitonId, effect, targetPattern, text);
    }

    override function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        if (context.damage > 0) {
            triggerEffectOnTargets(context.target, state, result);
        }
    }

    override public function equalsTo(other:Effect):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, OnAttackTrigger)) {
            return false;
        }

        var otherEffect = cast(other, OnAttackTrigger);

        return this.effect.equalsTo(otherEffect.effect);
    }

    override public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 + effect.getHashCode();
        return hash;
    }

    override function clone():Effect {
        return new OnAttackTrigger(fruitonId, effect, targetPattern, text);
    }
}