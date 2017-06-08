package fruiton.kernel;

class Position  {

	var x:Int;
	var y:Int;

	public function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}
	
	public function moveBy(positionChange:Position) {
		this.x += positionChange.x;
		this.y += positionChange.y;
	}
	
	public function toString():String {
		return "(" + x + ", " + y + ")";
	}

}