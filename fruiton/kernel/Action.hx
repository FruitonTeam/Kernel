package fruiton.kernel;

class Action {

    public var isValid(default, null):Bool;
    public var result(default, null):ActionExecutionResult;

    public function new() {
        isValid = true;
    }

    public function execute(state:GameState):Bool {
        return isValid;
    }

    public function toString():String {
        return "isValid: " + isValid;
    }
}
