package fruiton.kernel.actions;

import fruiton.dataStructures.Vector2;

class AttackActionContext extends ActionContext {

    public var source(default, default):Vector2;
    public var target(default, default):Vector2;
    public var damage(default, default):Int;

    public function new(damage:Int, source:Vector2, target:Vector2) {
        super();
        this.damage = damage;
        this.source = source;
        this.target = target;
    }

    public function clone():AttackActionContext {
        return new AttackActionContext(damage, source, target);
    }

    public function toString():String {
        return " AttackActionContext damage: " + Std.string(damage) + " source: " + Std.string(source) + " target: " + Std.string(target);
    }

    override public function equalsTo(other:ActionContext):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, AttackActionContext)) {
            return false;
        }

        var otherAttackContext = cast(other, AttackActionContext);

        var isDamageEqual:Bool =
            (this.damage == otherAttackContext.damage);

        var isSourceEqual:Bool =
            (this.source == otherAttackContext.source) ||
            (this.source != null && this.target.equalsTo(otherAttackContext.source));

        var isTargetEqual:Bool =
            (this.target == otherAttackContext.target) ||
            (this.target != null && this.target.equalsTo(otherAttackContext.target));

        return isDamageEqual && isSourceEqual && isTargetEqual;
    }
}