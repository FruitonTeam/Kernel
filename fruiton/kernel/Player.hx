package fruiton.kernel;

class Player {

    public var id(default, null):Int;

    public function new(id:Int) {
        this.id = id;
    }

    public function equals(other:Player):Bool {
        return this.id == other.id;
    }
}
