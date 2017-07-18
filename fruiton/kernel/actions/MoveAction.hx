package fruiton.kernel.actions;

import fruiton.kernel.events.MoveEvent;

class MoveAction extends Action {

    public var actionContext(default, null):MoveActionContext;

    public function new(context:MoveActionContext) {
        this.actionContext = context;
    }

    function validate(state:GameState, context:MoveActionContext):Bool {
        return
            context.source != null &&
            state.field.exists(context.source) &&
            state.field.get(context.source).fruiton != null &&
            context.target != null &&
            state.field.exists(context.target) &&
            state.turnState.moveCount > 0;
    }

    override public function execute(state:GameState):ActionExecutionResult {
        var result:ActionExecutionResult = new ActionExecutionResult();
        result.isValid = validate(state, actionContext);
        if (!result.isValid) {
            return result;
        }

        var newContext:MoveActionContext = actionContext.clone();
        var fruiton:Fruiton = state.field.get(newContext.source).fruiton;

        // Following may be while cycle through delegates
        if (result.isValid) {
            fruiton.onBeforeMove(newContext, state, result);
        }
        if (result.isValid) {
            moveFruiton(fruiton, newContext, state, result);
        }
        if (result.isValid) {
            fruiton.onAfterMove(newContext, state, result);
        }

        return result;
    }

    function moveFruiton(fruiton:Fruiton, context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        state.turnState.moveCount--;
        state.field.get(context.target).fruiton = state.field.get(context.source).fruiton;
        state.field.get(context.source).fruiton = null;
        fruiton.moveTo(context.target);

        result.events.push(new MoveEvent(1, context.source, context.target));
    }

    override public function toString():String {
        return super.toString() + " MoveAction: " + Std.string(actionContext);
    }
}
