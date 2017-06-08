package fruiton.kernel;


class Piece
{
	var id:Int;
	var pieceId:String;

	var baseHealth:Int;
	var maxHealth:Int;
	var currentHealth:Int;

	var baseAttack:Int;
	var currentAttack:Int;

	public var position:Position;

	public function new(id:Int, pieceId:String, position:Position)
	{
		this.id = id;
		this.pieceId = pieceId;
		this.position = position;
		this.baseHealth = this.maxHealth = this.currentHealth = 5;
		this.baseAttack = this.currentAttack = 3;
	}

	public function toString():String
	{
		return id + ":" + pieceId + "@" + position;
	}
}