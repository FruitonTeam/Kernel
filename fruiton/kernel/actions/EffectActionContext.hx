package fruiton.kernel.actions;

import fruiton.kernel.effects.Effect;
import fruiton.dataStructures.Vector2;

class EffectActionContext extends TargetableActionContext {

    public var effect(default, default):Effect;

    public function new(effect:Effect, source:Vector2, target:Vector2) {
        super(source, target);
        this.effect = effect;
    }

    public function clone():EffectActionContext {
        return new EffectActionContext(effect, source, target);
    }

    public function toString():String {
        return " EffectActionContext effect: " + Std.string(effect) + " source: " + Std.string(source) + " target: " + Std.string(target);
    }

    override public function equalsTo(other:ActionContext):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, EffectActionContext)) {
            return false;
        }

        var otherEffectContext = cast(other, EffectActionContext);

        var isEffectEqual:Bool =
        (this.effect == otherEffectContext.effect) ||
        (this.effect != null && this.effect.equalsTo(otherEffectContext.effect));


        var isSourceEqual:Bool =
        (this.source == otherEffectContext.source) ||
        (this.source != null && this.target.equalsTo(otherEffectContext.source));

        var isTargetEqual:Bool =
        (this.target == otherEffectContext.target) ||
        (this.target != null && this.target.equalsTo(otherEffectContext.target));

        return isEffectEqual && isSourceEqual && isTargetEqual;
    }
}