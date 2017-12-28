package fruiton.kernel.effects;

import fruiton.kernel.effects.contexts.EffectContext;
import fruiton.kernel.events.ModifyAttackEvent;

class LoweredAttackEffect extends Effect {

    public var amount(default, null):Int;

    public function new(fruitonId:Int, amount:Int){
        super(fruitonId);
        this.amount = amount;
    }

    override public function tryAddEffect(context: EffectContext, state: GameState, result:ActionExecutionResult) : Bool {
        var target = state.field.get(context.target).fruiton;
        var currentAttack = target.currentAttributes.damage;
        if (currentAttack <= 1) {
            return false;
        }
        var newAttack = cast Math.max(1, target.currentAttributes.damage - amount);
        target.currentAttributes.damage = newAttack;
        result.events.push(new ModifyAttackEvent(1, target.position, newAttack));
        return true;
    }

    override public function tryRemoveEffect(context: EffectContext, state: GameState, result:ActionExecutionResult) : Bool {
        var target = state.field.get(context.target).fruiton;
        if (target != null) {
            target.currentAttributes.damage += amount;
        }
        return true;
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

    override public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 + amount;
        return hash;
    }

    override function clone():Effect {
        return new LoweredAttackEffect(fruitonId, amount);
    }
}