package fruiton.kernel;

import fruiton.dataStructures.Vector2;
import haxe.Serializer;
import haxe.Unserializer;

typedef FieldArray = Array<Array<Tile>>;

class Field {

    var field:FieldArray;

    @:keep
    function hxSerialize(s:Serializer) {
        Serializer.USE_CACHE = true;
        s.serialize(field);
    }

    @:keep
    function hxUnserialize(u:Unserializer) {
        field = u.unserialize();
    }

    public function new(field:FieldArray) {
        this.field = field;
    }

    public function clone():Field {
        return new Field([for (c in field) [for (t in c) t.clone()]]);
    }

    // Get and set may be done via @:arrayAccess and abstract, but it seems too cumbersome
    public function get(key:Vector2):Tile {
        return field[key.x][key.y];
    }

    public function set(key:Vector2, value:Tile):Tile {
        field[key.x][key.y] = value;
        return value;
    }

    /**
     * Bound check for given position.
     * @param key Position to check
     * @return If given position in in bounds of this field
     */
    public function exists(key:Vector2):Bool {
        return
            key.x >= 0 &&
            key.x < field.length &&
            key.y >= 0 &&
            key.y < field[key.x].length;
    }
}
