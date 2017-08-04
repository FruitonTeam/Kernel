package fruiton.kernel.actions;

class EndTurnActionContext extends ActionContext {

    public function new() {
    }

    public function clone():EndTurnActionContext {
        var newContext:EndTurnActionContext = new EndTurnActionContext();
        return newContext;
    }

    public function toString():String {
        return "EndTurnActionContext";
    }
}