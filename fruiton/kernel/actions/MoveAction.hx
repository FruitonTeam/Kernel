package fruiton.kernel.actions;

import fruiton.kernel.events.MoveEvent;

class MoveAction extends Action {
    
    public var source(default, null):Position;
    public var target(default, null):Position;

    public function new(source:Position, target:Position) {
        super();
        this.source = source;
        this.target = target;
    }

    function validate(state:GameState) {
        isValid = 
            source != null && 
            state.field.get(source).fruiton != null && 
            target != null &&
            state.turnState.moveCount > 0;
    }

    override public function execute(state:GameState):Bool {
        validate(state);
        if (!isValid) {
            return isValid;
        }

        result = new ActionExecutionResult();

        var fruiton:Fruiton = state.field.get(source).fruiton;

        // Following may be while cycle through delegates
        if (isValid) {
            fruiton.onBeforeMove(this, state);
        }
        if (isValid) {
            moveFruiton(fruiton, state);
        }
        if (isValid) {
            fruiton.onAfterMove(this, state);
        }

        return isValid;
    }

    function moveFruiton(fruiton:Fruiton, state:GameState) {
        state.turnState.moveCount--;
        state.field.get(target).fruiton = state.field.get(source).fruiton;
        state.field.get(source).fruiton = null;
        fruiton.moveTo(target);

        result.events.push(new MoveEvent(1, source, target));
    }

    override public function toString():String {
        return super.toString() + " MoveAction source: " + Std.string(source) + " target: " + Std.string(target);
    }
}
