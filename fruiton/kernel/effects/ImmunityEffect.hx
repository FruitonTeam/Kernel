package fruiton.kernel.effects;

import fruiton.kernel.effects.contexts.EffectContext;

class ImmunityEffect extends Effect {

    var immunityId : Int;

    public function new(immunityId: Int) {
        this.immunityId = immunityId;
        super();
    }

    override public function tryAddEffect(context: EffectContext, state: GameState, result:ActionExecutionResult) : Bool {
        var target = state.field.get(context.target).fruiton;
        target.currentAttributes.addImunity(immunityId);
        return true;
    }

    override public function tryRemoveEffect(context: EffectContext, state: GameState, result:ActionExecutionResult) : Bool {
        var target = state.field.get(context.target).fruiton;
        target.currentAttributes.removeImunity(immunityId);
        return true;
    }

    override public function equalsTo(other:Effect):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, ImmunityEffect)) {
            return false;
        }

        var otherEffect = cast(other, ImmunityEffect);

        return immunityId == otherEffect.immunityId;
    }

    override public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 + immunityId;
        return hash;
    }

    override function clone():Effect {
        return new ImmunityEffect(immunityId);
    }
}