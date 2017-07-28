package fruiton.kernel;

/**
 *  Immutable class representing 2D position on the desk
 */
class Position  {

	public var x(default, null):Int;
	public var y(default, null):Int;

	public function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}

	/**
	 *  Memberwise multiplies this position by given scalar value
	 *  @param scalar - number to multiply this position with
	 *  @return Result of multiplication as a new Position
	 */
	public function mul(scalar:Int):Position {
		return new Position(x * scalar, y * scalar);
	}

	/**
	 *  Memberwise add two positions together
	 *  @param other - position to add to this
	 *  @return Result of addition as a new Position
	 */
	public function add(other:Position):Position {
		return new Position(x + other.x, y + other.y);
	}

	public function toString():String {
		return "(" + x + ", " + y + ")";
	}

	public function clone():Position {
		return new Position(this.x, this.y);
	}

	public function equals(other:Position):Bool {
		return x == other.x && y == other.y;
	}
}