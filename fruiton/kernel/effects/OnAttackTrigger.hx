package fruiton.kernel.effects;

import fruiton.kernel.actions.AttackActionContext;
import fruiton.kernel.actions.EffectActionContext;

class OnAttackTrigger extends Effect {

    var effect:Effect;

    public function new(effect:Effect){
        super();
        this.effect = effect;
    }

    override function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        if (context.damage > 0) {
            var target = state.field.get(context.target).fruiton;
            if (target != null) {
                var effectContext = new EffectActionContext(
                                        effect,
                                        context.source,
                                        context.target
                );
                target.addEffect(effect, effectContext, state, result);
            }
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
}