package fruiton.kernel;

import fruiton.dataStructures.Vector2;

class Tile {

    public var fruiton(default, default):Fruiton;
    public var position(default, null):Vector2;

    public function new(position:Vector2) {
        this.fruiton = null;
        this.position = position;
    }

    public function clone():Tile {
        var newTile:Tile = new Tile(this.position);
        return newTile;
    }

    public function toString():String {
        return "Tile Position: " + Std.string(position) + " " + Std.string(fruiton);
    }
}