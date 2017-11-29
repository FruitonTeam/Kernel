package fruiton.kernel.effects.contexts;

import fruiton.kernel.effects.Effect;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.actions.ActionContext;

class EffectContext extends ActionContext {

    public var effect(default, default):Effect;
    public var target(default, default):Vector2;

    public function new(effect:Effect, target:Vector2) {
        super();
        this.effect = effect;
        this.target = target;
    }

    public function clone():EffectContext {
        return new EffectContext(effect, target);
    }

    public function toString():String {
        return " EffectActionContext effect: " + Std.string(effect) + " target: " + Std.string(target);
    }

    override public function equalsTo(other:ActionContext):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, EffectContext)) {
            return false;
        }

        var otherEffectContext = cast(other, EffectContext);

        var isEffectEqual:Bool =
            (this.effect == otherEffectContext.effect) ||
            (this.effect != null && this.effect.equalsTo(otherEffectContext.effect));

        var isTargetEqual:Bool =
            (this.target == otherEffectContext.target) ||
            (this.target != null && this.target.equalsTo(otherEffectContext.target));

        return isEffectEqual && isTargetEqual;
    }
}