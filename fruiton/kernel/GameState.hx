package fruiton.kernel;

import fruiton.kernel.actions.EndTurnAction;
import fruiton.kernel.actions.EndTurnActionContext;
import fruiton.dataStructures.Vector2;

typedef Fruitons = Array<Fruiton>;
typedef Players = Array<Player>;

/**
 * State of a single game
 */
class GameState  {

    public static var WIDTH(default, never):Int = 8;
    public static var HEIGHT(default, never):Int = 8;
    public static var NONE(default, never):Int = -1;

    public var field(default, null):Field;
    public var fruitons(default, null):Fruitons;

    var players:Players;
    var activePlayerIdx:Int;
    /**
     * Player whose turn it is
     */
    public var activePlayer(get, never):Player;

    public var turnState(default, null):TurnState;
    public var winner(default, null):Int;

    var actionCache:Array<Array<IKernel.Actions>>;

    public function new(players:Players, activePlayerIdx:Int, fruitons:Fruitons) {
        this.fruitons = fruitons;
        this.field = new Field([for (x in 0...WIDTH) [for (y in 0...HEIGHT) new Tile(new Vector2(x, y))]]);
        for (f in this.fruitons) {
            field.get(f.position).fruiton = f;
        }
        this.players = players;
        this.activePlayerIdx = activePlayerIdx;
        this.winner = NONE;
        this.turnState = new TurnState();
        this.actionCache = [for (x in 0...WIDTH) [for (y in 0...HEIGHT) null]];
    }

    public function clone():GameState {
        // TODO use different constructor in clone to avoid double initialization
        var newState:GameState = new GameState([], 0, []);
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
        newState.winner = this.winner;

        return newState;
    }

    /**
     * Ends current turn and initializes game state to next turn.
     */
    public function nextTurn() {
        turnState = new TurnState();
        activePlayerIdx = (activePlayerIdx + 1) % players.length;
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
        actions.push(new EndTurnAction(new EndTurnActionContext()));

        return actions;
    }

    /**
     * Generates all possible actions in this state of game doable from given `position`.
     * Actions do not have to be valid.
     * If there is no fruiton at `position` or `position` is not valid only end turn action is returned.
     * @return IKernel.Actions available in this game state doable from `position`.
     */
    public function getAllActionsFrom(position:Vector2):IKernel.Actions {
        var actions:IKernel.Actions = new IKernel.Actions();

        if (field.exists(position)) {
            if (actionCache[position.x][position.y] != null) {
                return actionCache[position.x][position.y];
            }
            if (field.get(position).fruiton != null) {
                actions = actions.concat(field.get(position).fruiton.getAllActions(this));
            }
        }

        // Player can always end turn
        actions.push(new EndTurnAction(new EndTurnActionContext()));

        if (field.exists(position)) {
            actionCache[position.x][position.y] = actions.copy();
        }

        return actions;
    }

    function get_activePlayer():Player {
        return players[activePlayerIdx];
    }
}