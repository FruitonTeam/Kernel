package fruiton.kernel.actions;

class Action {

    public function execute(state:GameState):ActionExecutionResult {
        return new ActionExecutionResult();
    }

    public function toString():String {
        return "Action";
    }
}
