package fruiton.kernel.effects;

import fruiton.kernel.actions.EffectActionContext;

class LoweredAttackEffect extends Effect {

    public var amount(default, null):Int;

    public function new(amount: Int){
        super();
        this.amount = amount;
    }

    override public function onBeforeEffectAdded(context: EffectActionContext, state: GameState, result:ActionExecutionResult) {
        super.onBeforeEffectAdded(context, state, result);
        if (context.effect == this) {
            var target = state.field.get(context.target).fruiton;
            if (target.damage <= 1) {
                result.isValid = false;
            }
        }
    }

    override public function onAfterEffectAdded(context: EffectActionContext, state: GameState, result:ActionExecutionResult) {
        super.onAfterEffectAdded(context, state, result);
        if (context.effect == this) {
            var target = state.field.get(context.target).fruiton;
            if (target != null) {
                target.damage = cast Math.max(1, target.damage - amount);
            }
        }
    }

    override public function onBeforeEffectRemoved(context: EffectActionContext, state: GameState, result:ActionExecutionResult) {
        super.onBeforeEffectRemoved(context, state, result);
        if (context.effect == this) {
            var target = state.field.get(context.target).fruiton;
            if (target != null) {
                target.damage += amount;
            }
        }
    }

    override public function equalsTo(other:Effect):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, LoweredAttackEffect)) {
            return false;
        }

        var otherEffect = cast(other, LoweredAttackEffect);

        return this.amount == otherEffect.amount;
    }
}