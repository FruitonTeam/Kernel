package fruiton.kernel;

import fruiton.kernel.exceptions.InvalidActionException;
import fruiton.kernel.actions.Action;
import haxe.ds.GenericStack;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.events.GameOverEvent;
import fruiton.kernel.events.TimeExpiredEvent;
import haxe.ds.StringMap;

typedef ActionStack = GenericStack<Action>;

class Kernel implements IKernel {

    /**
     * Time in seconds a player has to make moves
     */
    public static var turnTimeLimit(default, default):Float = 90; // TODO change to non static variable loaded from db

    public var currentState(default, null):GameState;

    // Current ID that is free to use for fruiton.
    var currentId(default, null):Int;

    public function new(p1:Player, p2:Player, fruitons:GameState.Fruitons, ?settings:GameSettings) {
        if (settings == null) {
            settings = GameSettings.createDefault();
        }
        this.currentState = new GameState([p1, p2], 0, fruitons, settings);
        currentId = 0;
        for(fruiton in fruitons) {
            fruiton.id = currentId;
            fruiton.applyEffectsOnGameStart(currentState);
            currentId++;
        }
    }

    /**
     * Sets all things necessary to start the game and resets round timer
     * Used to decouple Kernel initialization and game start.
     */
    public function startGame() {
        currentState.resetTurn();
    }

    public function getAllValidActions():IKernel.Actions {
        var allActions:IKernel.Actions = currentState.getAllActions();
        return pruneInvalidActions(allActions);
    }

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

    public function performAction(userAction:Action):IKernel.Events {
        if (userAction == null) {
            throw new InvalidActionException("Null action");
        }

        var eventBuffer:IKernel.Events = new IKernel.Events();

        if (userAction.dependsOnTurnTime &&
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
            if (currentState.losers.length > 0) {
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
