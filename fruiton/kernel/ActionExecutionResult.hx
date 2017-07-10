package fruiton.kernel;

import haxe.ds.GenericStack;

class ActionExecutionResult {

    public var events(default, null):Array<Event>;
    public var actions(default, null):GenericStack<Action>;

    public function new() {
        this.events = [];
        this.actions = new GenericStack<Action>();
    }
}