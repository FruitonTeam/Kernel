package fruiton.kernel.effects;

import fruiton.kernel.actions.AddEffectAction;
import fruiton.kernel.actions.AttackActionContext;
import fruiton.kernel.actions.EffectActionContext;

class LowerAttackOnAttackEffect extends Effect {

    var amount: Int;

    public function new(amount:Int){
        super();
        this.amount = amount;
    }

    override function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        if (context.damage > 0) {
            var target = state.field.get(context.target).fruiton;
            if (target != null) {
                result.actions.add(
                    new AddEffectAction(
                        new EffectActionContext(
                            new LoweredAttackEffect(amount),
                            context.source,
                            context.target
                        ),
                        false
                    )
                );
            }
        }
    }

    override public function equalsTo(other:Effect):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, LowerAttackOnAttackEffect)) {
            return false;
        }

        var otherEffect = cast(other, LowerAttackOnAttackEffect);

        return this.amount == otherEffect.amount;
    }

    override public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 + amount;
        return hash;
    }
}