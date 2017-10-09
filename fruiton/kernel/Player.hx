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
        var p0 = Macros.getPrime();
        var p1 = Macros.getPrime();

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash  = hash * p1 +  id;
        return hash;
    }
}
