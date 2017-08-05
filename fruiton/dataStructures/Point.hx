package fruiton.dataStructures;

import fruiton.IEquitable;

/**
 * Base class for abstract vector
 * Should not be used on its own since it contains only data
 * For more functionality see Vector2
 */
class Point implements IEquitable<Point> {

    public var x(default, null):Int;
    public var y(default, null):Int;

    public function new(x:Int, y:Int) {
        this.x = x;
        this.y = y;
    }

    public function equalsTo(other:Point):Bool {
        if (other == null) {
            return false;
        }
        return this.x == other.x && this.y == other.y;
    }
}