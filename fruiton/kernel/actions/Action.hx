package fruiton.kernel.actions;

import fruiton.IAbstractClass;
import fruiton.IEquitable;

class Action implements IAbstractClass implements IEquitable<Action> {

    public var dependsOnTurnTime(default, null):Bool;

    function new() {
        this.dependsOnTurnTime = true;
    }

    public function execute(state:GameState):ActionExecutionResult;

    public function toString():String {
        return "Action";
    }

    public function equalsTo(other:Action):Bool;

    public function getId():Int;
}
