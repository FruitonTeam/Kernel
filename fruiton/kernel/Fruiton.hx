package fruiton.kernel;

import fruiton.kernel.actions.MoveAction;

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

    public function onBeforeMove(action:MoveAction, state:GameState) {
        // Modify action and game state
        trace("onBeforeMove Fruiton: " + id + " Action: " + action);
    }

    public function onAfterMove(action:MoveAction, state:GameState) {
        // Modify action and game state
        trace("onAfterMove Fruiton: " + id + " Action: " + action);
    }

    public function moveTo(newPosition:Position) {
        position = newPosition;
    }

    public function toString():String {
        return "Fruiton Id: " + id + " Position: " + Std.string(position);
    }
}