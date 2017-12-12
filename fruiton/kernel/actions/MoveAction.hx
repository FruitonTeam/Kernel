package fruiton.kernel.actions;

import fruiton.kernel.events.MoveEvent;

class MoveAction extends TargetableAction<MoveActionContext> {

    public static var ID:Int = 2;

    public function new(context:MoveActionContext) {
        super(context);
    }

    override function validate(state:GameState, context:MoveActionContext):Bool {
        var result:Bool =
            super.validate(state, context) &&
            context != null &&
            context.source != null &&
            state.field.exists(context.source) &&
            state.field.get(context.source).fruiton != null &&
            !state.turnState.usedAbility;

        if (!result) return result;

        var sourceFruiton:Fruiton = state.field.get(context.source).fruiton;

        result = result &&
            sourceFruiton.owner.equals(state.activePlayer) &&
            context.target != null &&
            state.field.exists(context.target) &&
            state.field.get(context.target).fruiton == null &&
            state.turnState.moveCount > 0;

        return result;
    }

    override function executeImpl(state:GameState, result:ActionExecutionResult) {
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
    }

    function moveFruiton(fruiton:Fruiton, context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        state.turnState.actionPerformer = fruiton;
        state.turnState.moveCount--;
        state.field.get(context.target).fruiton = state.field.get(context.source).fruiton;
        state.field.get(context.source).fruiton = null;
        fruiton.moveTo(context.target);

        result.events.push(new MoveEvent(1, context.source, context.target));
    }

    override public function toString():String {
        return super.toString() + " MoveAction:" + Std.string(actionContext);
    }

    override public function equalsTo(other:Action):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, MoveAction)) {
            return false;
        }

        var otherMoveAction = cast(other, MoveAction);
        return
            (this.actionContext == otherMoveAction.actionContext) ||
            (this.actionContext != null && this.actionContext.equalsTo(otherMoveAction.actionContext));
    }

    override public function getId():Int {
        return ID;
    }

    override public function toUniqueString():String {
        return Std.string(ID) + Std.string(actionContext.source) + Std.string(actionContext.target);
    }
}
