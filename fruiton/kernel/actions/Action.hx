package fruiton.kernel.actions;

import fruiton.IAbstractClass;
import fruiton.IEquitable;

class Action implements IAbstractClass implements IEquitable<Action> {

    function new() {

    }

    public function execute(state:GameState):ActionExecutionResult;

    public function toString():String {
        return "Action";
    }

    public function equals(other:Action):Bool;
}
