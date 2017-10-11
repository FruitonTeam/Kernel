package fruiton.kernel.effects;

import fruiton.kernel.actions.AddEffectAction;
import fruiton.kernel.actions.AttackActionContext;
import fruiton.kernel.actions.EffectActionContext;

class LowerAttackOnAttack extends Effect {

    var amount: Int;

    public function new(owner: Fruiton, amount:Int = 1){
        super(owner);
        name = "lower-attack-on-attack";
        this.amount = amount;
    }

    override function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        if (context.damage > 0) {
            var target = state.field.get(context.target).fruiton;
            if (target != null) {
                result.actions.add(
                    new AddEffectAction(
                        new EffectActionContext(
                            target,
                            new LoweredAttackEffect(target)
                        ),
                        true
                    )
                );
            }
        }
    }

    override public function equalsTo(other:Effect):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, LowerAttackOnAttack)) {
            return false;
        }

        var otherEffect = cast(other, LowerAttackOnAttack);

        return (this.owner.id == otherEffect.owner.id) &&
        this.amount == otherEffect.amount;
    }
}