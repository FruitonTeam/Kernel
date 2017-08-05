package fruiton.kernel.actions;

import fruiton.dataStructures.Vector2;

class MoveActionContext extends ActionContext {

    public var source(default, default):Vector2;
    public var target(default, default):Vector2;

    public function new(source:Vector2, target:Vector2) {
        super();
        this.source = source;
        this.target = target;
    }

    public function clone():MoveActionContext {
        return new MoveActionContext(source, target);
    }

    public function toString():String {
        return " MoveActionContext source: " + Std.string(source) + " target: " + Std.string(target);
    }

    override public function equals(other:ActionContext):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, MoveActionContext)) {
            return false;
        }

        var otherMoveContext = cast(other, MoveActionContext);
        return
            this.source != null &&
            this.source.equals(otherMoveContext.source) &&
            this.target != null &&
            this.target.equals(otherMoveContext.target);
    }
}