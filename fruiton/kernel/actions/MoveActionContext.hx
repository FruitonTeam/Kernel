package fruiton.kernel.actions;

import fruiton.dataStructures.Vector2;

class MoveActionContext extends TargetableActionContext {

    public function new(source:Vector2, target:Vector2) {
        super(source, target);
    }

    public function clone():MoveActionContext {
        return new MoveActionContext(source, target);
    }

    public function toString():String {
        return " MoveActionContext source: " + Std.string(source) + " target: " + Std.string(target);
    }

    override public function equalsTo(other:ActionContext):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, MoveActionContext)) {
            return false;
        }

        var otherMoveContext = cast(other, MoveActionContext);

        var isSourceEqual:Bool =
            (this.source == otherMoveContext.source) ||
            (this.source != null && this.source.equalsTo(otherMoveContext.source));

        var isTargetEqual:Bool =
            (this.target == otherMoveContext.target) ||
            (this.target != null && this.target.equalsTo(otherMoveContext.target));

        return isSourceEqual && isTargetEqual;
    }
}