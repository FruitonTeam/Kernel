package fruiton.kernel.actions;

import fruiton.dataStructures.Vector2;

class TargetableActionContext extends ActionContext {

    public var source(default, default):Vector2;
    public var target(default, default):Vector2;

    function new(source:Vector2, target:Vector2) {
        super();
        this.source = source;
        this.target = target;
    }
}