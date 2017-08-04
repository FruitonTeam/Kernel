package fruiton.dataStructures;

/**
 * Immutable class representing 2D vector
 */
 @:forward(x, y)
abstract Vector2(Point)  {

	public function new(x:Int, y:Int) {
		this = new Point(x, y);
	}

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
	public function unaryMinus():Vector2 {
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

	public function equals(other:Vector2):Bool {
		return this.x == other.x && this.y == other.y;
	}
}