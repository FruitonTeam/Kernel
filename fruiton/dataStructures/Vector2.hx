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
	public function mul(scalar:Int):Vector2 {
		return new Vector2(this.x * scalar, this.y * scalar);
	}

	/**
	 * Memberwise add two vectors together
	 * @param other - vector to add to this
	 * @return Result of addition as a new Vector2
	 */
	public function add(other:Vector2):Vector2 {
		return new Vector2(this.x + other.x, this.y + other.y);
	}

	public function toString():String {
		return "(" + this.x + ", " + this.y + ")";
	}

	public function clone():Vector2 {
		return new Vector2(this.x, this.y);
	}

	public function equals(other:Vector2):Bool {
		return this.x == other.x && this.y == other.y;
	}
}