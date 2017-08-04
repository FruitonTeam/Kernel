package fruiton.kernel.actions;

import fruiton.dataStructures.Vector2;

class MoveActionContext extends ActionContext {

    public var source(default, default):Vector2;
    public var target(default, default):Vector2;

    public function new(source:Vector2, target:Vector2) {
        this.source = source;
        this.target = target;
    }

    public function clone():MoveActionContext {
        return new MoveActionContext(source, target);
    }

    public function toString():String {
        return " MoveActionContext source: " + Std.string(source) + " target: " + Std.string(target);
    }
}