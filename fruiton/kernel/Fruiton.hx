package fruiton.kernel;

class Fruiton {

    public var id(default, null):Int;

    var position:Position;

    public function new(id:Int) {
        this.id = id;
    }

    public function clone():Fruiton {
        var newFruiton:Fruiton = new Fruiton(this.id);
        newFruiton.position = this.position;

        return newFruiton;
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