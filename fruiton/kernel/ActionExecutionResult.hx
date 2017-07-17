package fruiton.kernel;

class ActionExecutionResult {

    public var isValid(default, default):Bool;
    public var events(default, null):IKernel.Events;
    public var actions(default, null):Kernel.ActionStack;

    public function new() {
        isValid = false;
        this.events = new IKernel.Events();
        this.actions = new Kernel.ActionStack();
    }
}