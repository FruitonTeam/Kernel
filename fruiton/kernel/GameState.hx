package fruiton.kernel;

class GameState  {

	static var WIDTH(default, never):Int = 8;
	static var HEIGHT(default, never):Int = 8;

	var field(default, null):Array<Array<Tile>>;
	var fruitons(default, null):Array<Fruiton>;

	public function new() {
		this.fruitons = [];
		this.field = [for (x in 0...WIDTH) [for (y in 0...HEIGHT) new Tile(new Position(x, y))]];
	}

	public function clone():GameState {
		var newState:GameState = new GameState();
		// Clone all fields
		
		return newState;
	}
}