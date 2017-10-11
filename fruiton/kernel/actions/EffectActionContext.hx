package fruiton.kernel.actions;

import fruiton.kernel.effects.Effect;

class EffectActionContext extends ActionContext {

    public var owner(default, default):Fruiton;
    public var effect(default, default):Effect;

    public function new(owner:Fruiton, effect:Effect) {
        super();
        this.owner = owner;
        this.effect = effect;
    }

    public function clone():EffectActionContext {
        return new EffectActionContext(owner, effect);
    }

    public function toString():String {
        return " EffectActionContext owner: " + Std.string(owner) + " effect: " + Std.string(effect);
    }

    override public function equalsTo(other:ActionContext):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, EffectActionContext)) {
            return false;
        }

        var otherEffectContext = cast(other, EffectActionContext);

        return (this.owner.id == otherEffectContext.owner.id) &&
        this.effect.equalsTo(otherEffectContext.effect);
    }
}