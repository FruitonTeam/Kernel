package fruiton.kernel;

class Player {

    public var id(default, null):Int;

    public function new(id:Int) {
        this.id = id;
    }

    public function clone():Player {
        return new Player(id);
    }
}