package fruiton.kernel;

import haxe.Serializer;
import haxe.Unserializer;

class Player implements IHashable{

    public var id(default, null):Int;

    @:keep
    function hxSerialize(s:Serializer) {
        s.serialize(id);
    }

    @:keep
    function hxUnserialize(u:Unserializer) {
        id = u.unserialize();
    }

    public function new(id:Int) {
        this.id = id;
    }

    public function equals(other:Player):Bool {
        return this.id == other.id;
    }

    public function getHashCode() : Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash  = hash * p1 +  id;
        return hash;
    }
}
