package fruiton.kernel.actions;

import fruiton.kernel.events.EndTurnEvent;

class EndTurnAction extends Action {

    public var actionContext(default, null):EndTurnActionContext;

    public function new(context:EndTurnActionContext) {
        this.actionContext = context;
    }

    function validate(state:GameState, context:EndTurnActionContext):Bool {
        return true;
    }

    override public function execute(state:GameState):ActionExecutionResult {
        var result:ActionExecutionResult = new ActionExecutionResult();
        result.isValid = validate(state, actionContext);
        if (!result.isValid) {
            return result;
        }
        
        var newContext:EndTurnActionContext = actionContext.clone();

        for (f in state.fruitons) {
            if (!result.isValid) break;
            f.onBeforeTurnEnd(newContext, state, result);
        }

        if (result.isValid) {
            endTurn(newContext, state, result);
        }

        for (f in state.fruitons) {
            if (!result.isValid) break;
            f.onAfterTurnEnd(newContext, state, result);
        }

        return result;
    }

    function endTurn(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        state.nextTurn();
        result.events.push(new EndTurnEvent(0));
    }

    override public function toString():String {
        return super.toString() + " EndTurn";
    }
}
