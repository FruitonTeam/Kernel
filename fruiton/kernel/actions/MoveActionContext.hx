package fruiton.kernel.actions;

class MoveActionContext extends ActionContext {

    public var source(default, default):Position;
    public var target(default, default):Position;

    public function new(source:Position, target:Position) {
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