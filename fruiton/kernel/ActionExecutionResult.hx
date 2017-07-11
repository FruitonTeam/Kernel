package fruiton.kernel;

class ActionExecutionResult {

    public var events(default, null):IKernel.Events;
    public var actions(default, null):Kernel.ActionStack;

    public function new() {
        this.events = [];
        this.actions = new Kernel.ActionStack();
    }
}