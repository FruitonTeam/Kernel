package fruiton.kernel.actions;

import fruiton.IAbstractClass;

class Action implements IAbstractClass {

    public function execute(state:GameState):ActionExecutionResult;

    public function toString():String {
        return "Action";
    }
}
