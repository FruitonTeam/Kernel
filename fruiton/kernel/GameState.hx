package fruiton.kernel;

import fruiton.kernel.actions.EndTurnAction;
import fruiton.dataStructures.Vector2;

typedef Fruitons = Array<Fruiton>;
typedef Players = Array<Player>;

/**
 * State of a single game
 */
class GameState implements IHashable {

    public static var WIDTH(default, never):Int = 9;
    public static var HEIGHT(default, never):Int = 10;

    public var field(default, null):Field;
    public var fruitons(default, null):Fruitons;

    var players:Players;
    var activePlayerIdx:Int;

    /**
     * Player whose turn it is
     */
    public var activePlayer(get, never):Player;

    /**
     * Player whose turn it is not
     */
    public var otherPlayer(get, never):Player;

    public var turnState(default, null):TurnState;
    public var losers(default, null):Array<Int>;

    var actionCache:Array<Array<IKernel.Actions>>;

    /**
     * @param isClone True if constructor is called from clone method to avoid double initialization
     */
    public function new(players:Players, activePlayerIdx:Int, fruitons:Fruitons, settings:GameSettings, ?isClone:Bool = false) {
        if (!isClone) {
            this.fruitons = fruitons;
            this.field = new Field([for (x in 0...WIDTH) [for (y in 0...HEIGHT) new Tile(new Vector2(x, y), settings.map[x][y])]]);
            for (f in this.fruitons) {
                field.get(f.position).fruiton = f;
            }
            this.players = players;
            this.activePlayerIdx = activePlayerIdx;
            this.losers = [];
            this.turnState = new TurnState();
        }
        this.actionCache = [for (x in 0...WIDTH) [for (y in 0...HEIGHT) null]];
    }

    public function clone():GameState {
        var newState:GameState = new GameState([], 0, [], null, true);
        // Clone all fields
        newState.field = field.clone();
        newState.fruitons = [for (f in this.fruitons) f.clone()];
        for (f in newState.fruitons) {
            if (f.isAlive) {
                newState.field.get(f.position).fruiton = f;
            }
        }
        // Players are not cloned to remain the same as fruitons have them
        newState.players = [for (p in this.players) p];
        newState.activePlayerIdx = this.activePlayerIdx;
        newState.turnState = this.turnState.clone();
        newState.losers = this.losers.copy();

        return newState;
    }

    /**
     * Ends current turn and initializes game state to next turn.
     */
    public function nextTurn() {
        turnState = new TurnState();
        activePlayerIdx = 1 - activePlayerIdx;
    }

    /**
     * Generates all possible actions in this state of game.
     * Do not have to be valid.
     * @return IKernel.Actions available in this game state.
     */
    public function getAllActions():IKernel.Actions {
        var actions:IKernel.Actions = new IKernel.Actions();

        for (f in fruitons) {
            actions = actions.concat(f.getAllActions(this));
        }

        // Player can always end turn
        actions.push(EndTurnAction.createNew());

        return actions;
    }

    /**
     * Generates all possible actions in this state of game doable from given `position`.
     * Actions do not have to be valid.
     * If there is no fruiton at `position` or `position` is not valid only end turn action is returned.
     * @return IKernel.Actions available in this game state doable from `position`.
     */
    public function getAllActionsFrom(position:Vector2):IKernel.Actions {
        // Invalid position or no fruiton - no actions
        if (!field.exists(position) ||
            field.get(position).fruiton == null) {
            return [EndTurnAction.createNew()];
        }

        // Postion is valid - try cache first
        if (actionCache[position.x][position.y] != null) {
            return actionCache[position.x][position.y];
        }

        var actions:IKernel.Actions = field.get(position).fruiton.getAllActions(this);
        // Player can always end turn
        actions.push(EndTurnAction.createNew());
        actionCache[position.x][position.y] = actions.copy();

        return actions;
    }

    function get_activePlayer():Player {
        return players[activePlayerIdx];
    }

    function get_otherPlayer():Player {
        return players[1 - activePlayerIdx];
    }

    public function resetTurn() {
        turnState = new TurnState();
    }

    public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 +  activePlayerIdx;
        hash = hash * p1 +  turnState.getHashCode();
        hash = hash * p1 +  HashHelper.hashIterable(players);
        hash = hash * p1 +  HashHelper.hashIterable(fruitons);
        return hash;
    }

    // Find fruiton by id.
    public function findFruiton(id:Int):Fruiton {
        for (fruiton in fruitons) {
            if (fruiton.id == id) {
                return fruiton;
            }
        }
        return null;
    }
}