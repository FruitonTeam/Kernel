package fruiton.kernel;


class Player implements IHashable{

    public var id(default, null):Int;

    public function new(id:Int) {
        this.id = id;
    }

    public function equals(other:Player):Bool {
        return this.id == other.id;
    }
    
    public function getHashCode() : Int {
        return id * HashHelper.getPrime(0) + HashHelper.getPrime(1);
    }
}
