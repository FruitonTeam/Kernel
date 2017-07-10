package fruiton.kernel;

class Fruiton {

    public var id(default, null):Int;

    var position:Position;

    public function new(id:Int) {
        this.id = id;
    }

    public function onBeforeMove(action:MoveAction, state:GameState) {
        // Modify action and game state
        trace("onBeforeMove: " + id + " Action: " + action);
    }

    public function onAfterMove(action:MoveAction, state:GameState) {
        // Modify action and game state
        trace("onAfterMove: " + id + " Action: " + action);
    }
}