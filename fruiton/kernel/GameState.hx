package fruiton.kernel;

typedef Fruitons = Array<Fruiton>;
typedef Players = Array<Player>;

/**
 *  State of a single game
 */
class GameState  {

	public static var WIDTH(default, never):Int = 8;
	public static var HEIGHT(default, never):Int = 8;
	public static var NONE(default, never):Int = -1;

	public var field(default, null):Field;
	var fruitons(default, null):Fruitons;

	var players:Players;
	var activePlayerIdx:Int;

	public var turnState(default, null):TurnState;

	public var winner(default, null):Int;

	public function new(players:Players, activePlayerIdx:Int, fruitons:Fruitons) {
		this.fruitons = fruitons;
		this.field = new Field([for (x in 0...WIDTH) [for (y in 0...HEIGHT) new Tile(new Position(x, y))]]);
		for (f in this.fruitons) {
			field.get(f.position).fruiton = f;
		}
		this.players = players;
		this.activePlayerIdx = activePlayerIdx;
		this.winner = NONE;
		this.turnState = new TurnState();
	}

	public function clone():GameState {
		// TODO use different constructor in clone to avoid double initialization
		var newState:GameState = new GameState([], 0, []);
		// Clone all fields
		newState.field = field.clone();
		newState.fruitons = [for (f in this.fruitons) f.clone()];
		for (f in newState.fruitons) {
			newState.field.get(f.position).fruiton = f;
		}
		// Players are not cloned to remain the same as fruitons have them
		newState.players = [for (p in this.players) p];
		newState.turnState = this.turnState.clone();
		newState.winner = this.winner;

		return newState;
	}

	public function nextTurn() {
		turnState = new TurnState();
		activePlayerIdx = (activePlayerIdx + 1) % players.length;
	}
}