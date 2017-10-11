package fruiton.kernel.effects;

import fruiton.kernel.actions.AttackActionContext;

class LoweredAttackEffect extends Effect {

    var amount:Int;

    public function new(amount: Int = 1){
        name = "lowered-attack";
        this.amount = amount;
    }

    override public function onBeforeAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        context.damage -= 1;
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