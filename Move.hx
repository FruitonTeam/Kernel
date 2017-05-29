package;

class Move
{

	public var id:Int;
	public var positionChange:Position;

	public function new(id:Int, positionChange:Position)
	{
		this.id = id;
		this.positionChange = positionChange;
	}

	public function toString():String
	{
		return "Move " + id + " by " + positionChange;
	}
}