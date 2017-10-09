package fruiton.dataStructures;

/**
 * Immutable class representing 2D vector
 */
 @:forward
abstract Vector2(Point)
from Point
to Point {

    public function new(x:Int, y:Int) {
        this = new Point(x, y);
    }

    public static var ZERO:Vector2 = new Vector2(0, 0);

    /**
     * Memberwise multiplies this vector by given scalar value
     * @param scalar - number to multiply this vector with
     * @return Result of multiplication as a new Vector2
     */
    @:op(A * B)
    @:commutative // Enforces static
    public static function multiply(v:Vector2, scalar:Int):Vector2 {
        return new Vector2(v.x * scalar, v.y * scalar);
    }

    /**
     * Memberwise add two vectors together
     * @param other - vector to add to this
     * @return Result of addition as a new Vector2
     */
    @:op(A + B)
    public function add(other:Vector2):Vector2 {
        return new Vector2(this.x + other.x, this.y + other.y);
    }

    /**
     * Memberwise subtracts two vectors from each other
     * @param other - vector to subtract from this
     * @return Result of subtraction as a new Vector2
     */
    @:op(A - B)
    public function subtract(other:Vector2):Vector2 {
        return new Vector2(this.x - other.x, this.y - other.y);
    }

    /**
     * Creates oposite vector by unary minus operation
     * @return Vector2 oposite to this
     */
    @:op(-A)
    public function negate():Vector2 {
        return new Vector2(-this.x, -this.y);
    }

    public function toString():String {
        // Null check mandatory because abstract will try to access
        // its fields even if `this` is null e.g. in Std.string(...)
        if (this == null) {
            return "null";
        }
        return "(" + this.x + ", " + this.y + ")";
    }

    public function clone():Vector2 {
        return new Vector2(this.x, this.y);
    }

    /**
     * Tests value equality of two vectors
     * @return Whether are given vectors equal
     */
    @:op(A == B)
    public static function equalsTo(lhs:Vector2, rhs:Vector2):Bool {
        if (lhs == null) {
            return false;
        }
        return lhs.equalsTo(rhs);
    }

    /**
     * Tests value inequality of two vectors
     * @return Whether are given vectors not equal
     */
    @:op(A != B)
    public static function nequals(lhs:Vector2, rhs:Vector2):Bool {
        return !(lhs == rhs);
    }

    public static function compare(lhs:Vector2, rhs:Vector2):Int {
        if (lhs.x < rhs.x) {
            return -1;
        }
        if (lhs.x > rhs.x) {
            return 1;
        }
        // lhs.x == rhs.x
        if (lhs.y < rhs.y) {
            return -1;
        }
        if (lhs.y > rhs.y) {
            return 1;
        }
        return 0;
    }

    public function getHashCode() : Int {
        var p0 = HashHelper.getPrime(4);
        var p1 = HashHelper.getPrime(5);
        var hash = p0;

        hash = hash * p1 +  this.x;
        hash = hash * p1 +  this.y;
        return hash;
    }   
}