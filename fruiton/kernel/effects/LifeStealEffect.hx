package fruiton.kernel.effects;

import fruiton.kernel.actions.AttackActionContext;

class LifeStealEffect extends Effect {

    public function new() {
        super();
    }

    override function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        var sourceFruiton = state.field.get(context.source).fruiton;
        sourceFruiton.receiveHeal(context.damage, context.source, context.source, result);
    }

    override public function equalsTo(other:Effect):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, LifeStealEffect)) {
            return false;
        }

        return true;
    }

    override public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        return hash;
    }

    override function clone():Effect {
        return new LifeStealEffect();
    }
}