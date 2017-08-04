package fruiton.dataStructures;

/**
 * Base class for abstract vector
 * Should not be used on its own since it contains only data
 * For more functionality see Vector2
 */
class Point {

    public var x(default, null):Int;
    public var y(default, null):Int;

    public function new(x:Int, y:Int) {
        this.x = x;
        this.y = y;
    }
}