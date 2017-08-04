package fruiton.kernel.actions;

class GenAction<TContext> extends Action {

    public var actionContext(default, null):TContext;

    function new(context:TContext) {
        this.actionContext = context;
    }

    function validate(state:GameState, context:TContext):Bool;

    override public function execute(state:GameState):ActionExecutionResult {
        var result:ActionExecutionResult = new ActionExecutionResult();
        result.isValid = validate(state, actionContext);
        return result;
    }
}