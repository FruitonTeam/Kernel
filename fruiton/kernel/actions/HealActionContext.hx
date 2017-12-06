package fruiton.kernel.actions;

import fruiton.dataStructures.Vector2;

class HealActionContext extends TargetableActionContext {

    public var heal(default, default):Int;

    public function new(heal:Int, source:Vector2, target:Vector2) {
        super(source, target);
        this.heal = heal;
    }

    public function clone():HealActionContext {
        return new HealActionContext(heal, source, target);
    }

        public function toString():String {
        return " HealActionContext damage: " + Std.string(heal) + " source: " + Std.string(source) + " target: " + Std.string(target);
    }

    override public function equalsTo(other:ActionContext):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, HealActionContext)) {
            return false;
        }

        var otherAttackContext = cast(other, HealActionContext);

        var isHealEqual:Bool =
            (this.heal == otherAttackContext.heal);

        var isSourceEqual:Bool =
            (this.source == otherAttackContext.source) ||
            (this.source != null && this.target.equalsTo(otherAttackContext.source));

        var isTargetEqual:Bool =
            (this.target == otherAttackContext.target) ||
            (this.target != null && this.target.equalsTo(otherAttackContext.target));

        return isHealEqual && isSourceEqual && isTargetEqual;
    }
}