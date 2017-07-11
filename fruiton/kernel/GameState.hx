package fruiton.kernel;

/**
 *  State of a single game
 */
class GameState  {

	static var WIDTH(default, never):Int = 8;
	static var HEIGHT(default, never):Int = 8;
	public static var NONE(default, never):Int = -1;

	var field(default, null):Array<Array<Tile>>;
	var fruitons(default, null):Array<Fruiton>;

	var playerIds:Array<Int>;
	var activePlayerIdx:Int;

	var turnState:TurnState;

	public var winner(default, null):Int;

	public function new() {
		this.fruitons = [];
		this.field = [for (x in 0...WIDTH) [for (y in 0...HEIGHT) new Tile(new Position(x, y))]];
		this.playerIds = [1];
		this.activePlayerIdx = 0;
		this.winner = NONE;
		this.turnState = new TurnState();
	}

	public function clone():GameState {
		// TODO use different constructor in clone to avoid double initialization
		var newState:GameState = new GameState();
		// Clone all fields
		newState.field = [for (c in this.field) [for (tile in c) tile.clone()]];
		newState.fruitons = [for (f in this.fruitons) f.clone()];
		newState.playerIds = [for (id in this.playerIds) id];
		newState.turnState = this.turnState.clone();
		newState.winner = this.winner;

		return newState;
	}

	public function nextTurn() {
		turnState = new TurnState();
		activePlayerIdx = (activePlayerIdx + 1) % playerIds.length;
	}
}