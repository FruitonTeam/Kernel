package fruiton.kernel;

typedef FieldArray = Array<Array<Tile>>;

class Field {

    var field:FieldArray;

    public function new(field:FieldArray) {
        this.field = field;
    }

    public function clone():Field {
        return new Field([for (c in field) [for (t in c) t.clone()]]);
    }

    // Get and set may be done via @:arrayAccess and abstract, but it seems too cumbersome
    public function get(key:Position):Tile {
        return field[key.x][key.y];
    }

    public inline function set(key:Position, value:Tile):Tile {
        field[key.x][key.y] = value;
        return value;
    }
}
