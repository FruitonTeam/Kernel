package fruiton.kernel.actions;

import fruiton.kernel.events.EndTurnEvent;

class EndTurnAction extends GenericAction<EndTurnActionContext> {

    public static inline var ID:Int = 1;

    /**
     * Factory method to create an action with default context.
     */
    public static function createNew():EndTurnAction {
        return new EndTurnAction(new EndTurnActionContext());
    }

    /**
     * Private constructor since we can have only one. Instances should be
     * created using factory methods e.g. `createNew()`.
     */
    function new(context:EndTurnActionContext) {
        super(context);
        dependsOnTurnTime = false;
    }

    override function validate(state:GameState, context:EndTurnActionContext):Bool {
        return super.validate(state, context);
    }

    override function executeImpl(state:GameState, result:ActionExecutionResult) {
        var newContext:EndTurnActionContext = actionContext.clone();

        for (f in state.fruitons) {
            if (!result.isValid) {
                break;
            }
            f.onBeforeTurnEnd(newContext, state, result);
        }

        if (result.isValid) {
            endTurn(newContext, state, result);
        }

        for (f in state.fruitons) {
            if (!result.isValid) {
                break;
            }
            f.onAfterTurnEnd(newContext, state, result);
        }
    }

    function endTurn(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        state.nextTurn();
        result.events.push(new EndTurnEvent(0));
    }

    override public function toString():String {
        return super.toString() + " EndTurn";
    }

    override public function equalsTo(other:Action):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, EndTurnAction)) {
            return false;
        }

        var otherEndTurnAction = cast(other, EndTurnAction);
        return
            (this.actionContext == otherEndTurnAction.actionContext) ||
            (this.actionContext != null && this.actionContext.equalsTo(otherEndTurnAction.actionContext));
    }

    override public function getId():Int {
        return ID;
    }

    override public function toUniqueString():String {
        return Std.string(ID);
    }
}
