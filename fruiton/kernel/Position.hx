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
	
	public function moveBy(positionChange:Position):Position {
		return new Position(x + positionChange.x, y + positionChange.y);
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