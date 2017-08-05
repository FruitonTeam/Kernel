package fruiton.kernel.actions;

class EndTurnActionContext extends ActionContext {

    public function new() {
        super();
    }

    public function clone():EndTurnActionContext {
        var newContext:EndTurnActionContext = new EndTurnActionContext();
        return newContext;
    }

    public function toString():String {
        return "EndTurnActionContext";
    }

    override public function equalsTo(other:ActionContext):Bool {
        if (other == null) {
            return false;
        }

        return Std.is(other, EndTurnActionContext);
    }
}