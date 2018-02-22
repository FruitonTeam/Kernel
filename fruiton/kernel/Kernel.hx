package fruiton.kernel;

import fruiton.kernel.exceptions.InvalidActionException;
import fruiton.kernel.actions.Action;
import haxe.ds.GenericStack;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.events.GameOverEvent;
import fruiton.kernel.events.TimeExpiredEvent;
import haxe.ds.StringMap;
import fruiton.kernel.gameModes.GameMode;

typedef ActionStack = GenericStack<Action>;

class Kernel implements IKernel {

    /**
     * Time in seconds a player has to make moves
     */
    public static var turnTimeLimit(default, default):Float = 90; // TODO change to non static variable loaded from db

    public var currentState(default, default):GameState;
    public var infiniteTurnTime(default, null):Bool;
    var gameMode:GameMode;

    public function new(p1:Player, p2:Player, fruitons:GameState.Fruitons, settings:GameSettings, ?isClone:Bool, ?infiniteTurnTime:Bool = false) {
        this.infiniteTurnTime = infiniteTurnTime;
        if (!isClone) {
            gameMode = settings.gameMode;
            this.currentState = new GameState([p1, p2], 0, fruitons, settings, false, infiniteTurnTime);
            var currentId:Int = 0;
            for(fruiton in fruitons) {
                fruiton.id = currentId;
                fruiton.applyEffectsOnGameStart(currentState);
                currentId++;
            }
        }
    }

    /**
     * Creates deep copy of this instance of Kernel.
     * @return Exact deep copy of this kernel.
     */
    public function clone():Kernel {
        var newKernel:Kernel = new Kernel(null, null, null, null, true, this.infiniteTurnTime);
        newKernel.currentState = this.currentState.clone();
        newKernel.gameMode = this.gameMode.clone();
        return newKernel;
    }

    /**
     * Sets all things necessary to start the game and resets round timer
     * Used to decouple Kernel initialization and game start.
     */
    public function startGame() {
        currentState.resetTurn();
    }

    /**
     * Generates all valid actions which can be performed in current state
     * of this kernel.
     * @return All valid actions.
     */
    public function getAllValidActions():IKernel.Actions {
        var allActions:IKernel.Actions = currentState.getAllActions();
        return pruneInvalidActions(allActions);
    }

    /**
     * Generates all valid actions which can be performed by fruiton at
     * given position in current state of this kernel.
     * @param position - Position where fruiton whose actions you want stands.
     * @return All valid actions perfromable by fruiton on given position.
     */
    public function getAllValidActionsFrom(position:Vector2):IKernel.Actions {
        var allActions:IKernel.Actions = currentState.getAllActionsFrom(position);
        return pruneInvalidActions(allActions);
    }

    function pruneInvalidActions(allActions:IKernel.Actions):IKernel.Actions {
        var validActions:Array<Action> = new IKernel.Actions();
        var actionMap:StringMap<Bool> = new StringMap<Bool>();

        for (a in allActions) {
            // Do not return duplicate actions
            var unString = a.toUniqueString();
            if (actionMap.exists(unString)) {
                continue;
            }

            // Check validity
            // Early escape to avoid expensive GameState.clone()
            if (!a.isValid(currentState)) {
                continue;
            }
            var newState:GameState = currentState.clone();
            if (a.execute(newState).isValid) {
                validActions.push(a);
                actionMap.set(unString, true);
            }
        }

        return validActions;
    }

    /**
     * Performs given action on currentGameState and if valid changes this
     * gameState accordingly and sets it as currentGameState.
     * @param userAction - Action to perform.
     * @return Events given action generated.
     */
    public function performAction(userAction:Action):IKernel.Events {
        if (userAction == null) {
            throw new InvalidActionException("Null action");
        }

        var eventBuffer:IKernel.Events = new IKernel.Events();

        if (!this.infiniteTurnTime && userAction.dependsOnTurnTime &&
        currentState.turnState.endTime < Sys.time()) {
            eventBuffer = eventBuffer.concat(timeExpired());
            return eventBuffer;
        }

        var actions:ActionStack = new ActionStack();

        actions.add(userAction);

        while (!actions.isEmpty()) {
            // Clone game state for transaction like execution
            var newState:GameState = currentState.clone();

            var currentAction:Action = actions.pop();
            var result:ActionExecutionResult = currentAction.execute(newState);
            if (result.isValid) {
                currentState = newState;
                addActions(actions, result.actions);
                eventBuffer = eventBuffer.concat(result.events);
            } else { // action is invalid
                // Only user action cannot fail, other (generated) actions may fail silently
                if (currentAction == userAction) {
                    throw new InvalidActionException(Std.string(currentAction));
                }
            }

            // Is game over?
            if (gameMode.checkGameOver(currentState)) {
                eventBuffer = eventBuffer.concat(finishGame());
                break;
            }
        }

        return eventBuffer;
    }

    function finishGame():IKernel.Events {
        return [new GameOverEvent(1, currentState.losers)];
    }

    function timeExpired():IKernel.Events {
        return [new TimeExpiredEvent(1)];
    }

    // ==============
    // Helper methods
    // ==============
    function addActions(actions:ActionStack, newActions:ActionStack) {
        for (a in newActions) {
            actions.add(a);
        }
    }
}
