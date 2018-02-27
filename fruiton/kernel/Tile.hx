package fruiton.kernel;

import fruiton.dataStructures.Vector2;
import haxe.Serializer;
import haxe.Unserializer;

enum TileType {
    passable;
    impassable;
}

class Tile {

    public var fruiton(default, default):Fruiton;
    public var type(default, null):TileType;
    public var position(default, null):Vector2;

    @:keep
    function hxSerialize(s:Serializer) {
        s.serialize(fruiton);
        s.serialize(type);
        s.serialize(position);
    }

    @:keep
    function hxUnserialize(u:Unserializer) {
        fruiton = u.unserialize();
        type = u.unserialize();
        position = u.unserialize();
    }

    public var isEmpty(get, null):Bool;
    function get_isEmpty():Bool {
        return this.type == TileType.passable &&
            this.fruiton == null;
    }

    public function new(position:Vector2, type:TileType) {
        this.fruiton = null;
        this.type = type;
        this.position = position;
    }

    public function clone():Tile {
        var newTile:Tile = new Tile(this.position, this.type);
        return newTile;
    }

    public function toString():String {
        return "Tile Position: " + Std.string(position) + " type: " + Std.string(type) + " " + Std.string(fruiton);
    }
}