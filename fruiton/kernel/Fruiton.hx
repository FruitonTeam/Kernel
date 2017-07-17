package fruiton.kernel;

import fruiton.kernel.actions.MoveAction;
import fruiton.kernel.actions.MoveActionContext;

class Fruiton {

    public var id(default, null):Int;
    public var position(default, null):Position;
    public var owner(default, null):Player;

    public function new(id:Int, position:Position, owner:Player) {
        this.id = id;
        this.position = position;
        this.owner = owner;
    }

    public function clone():Fruiton {
        // Player is no cloned to remain the same as in GameState
        return new Fruiton(this.id, this.position.clone(), this.owner);
    }

    public function getAllActions(state:GameState):IKernel.Actions {
        var allActions:IKernel.Actions = new IKernel.Actions();
        // Get all move actions
        // For now consider moving only by one in all directions
        allActions.push(new MoveAction(new MoveActionContext(position, position.moveBy(new Position(1, 0)))));
        allActions.push(new MoveAction(new MoveActionContext(position, position.moveBy(new Position(0, 1)))));
        allActions.push(new MoveAction(new MoveActionContext(position, position.moveBy(new Position(-1, 0)))));
        allActions.push(new MoveAction(new MoveActionContext(position, position.moveBy(new Position(0, -1)))));
        
        return allActions;
    }

    // ==============
    // Event handlers
    // ==============
    public function onBeforeMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeMove Fruiton: " + id + " Context: " + context);
    }

    public function onAfterMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterMove Fruiton: " + id + " Context: " + context);
    }

    public function moveTo(newPosition:Position) {
        position = newPosition;
    }

    public function toString():String {
        return "Fruiton Id: " + id + " Position: " + Std.string(position);
    }
}