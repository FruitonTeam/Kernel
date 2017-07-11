package fruiton.kernel;

class Tile {
    
    public var fruiton(default, default):Fruiton;
    public var position(default, null):Position;

    public function new(position:Position) {
        this.fruiton = null;
        this.position = position;
    }

    public function clone():Tile {
        var newTile:Tile = new Tile(this.position);
        newTile.fruiton = this.fruiton;
        return newTile;
    }
}