package fruiton.kernel.actions;

class GenericAction<TContext:(ActionContext)> extends Action {

    public var actionContext(default, null):TContext;

    public static var ID:Int = 123;

    function new(context:TContext) {
        super();
        this.actionContext = context;
    }

    /**
     * Template interface method
     * @param state State upon which this action operates
     * @return Result of action execution
     */
    @:final
    override public function execute(state:GameState):ActionExecutionResult {
        var result:ActionExecutionResult = new ActionExecutionResult();
        result.isValid = validate(state, actionContext);
        if (!result.isValid) {
            return result;
        }

        executeImpl(state, result);

        return result;
    }

    function validate(state:GameState, context:TContext):Bool {
        return !dependsOnTurnTime ||
            state.turnState.endTime >= Sys.time();
    }

    function executeImpl(state:GameState, result:ActionExecutionResult);
}