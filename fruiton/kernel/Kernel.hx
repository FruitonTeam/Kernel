package fruiton.kernel;

import fruiton.kernel.exceptions.InvalidActionException;
import fruiton.kernel.actions.Action;
import haxe.ds.GenericStack;
import fruiton.dataStructures.collections.ArrayOfEquitables;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.events.GameOverEvent;

typedef ActionStack = GenericStack<Action>;

class Kernel implements IKernel {

    public var currentState(default, null):GameState;

    public function new(p1:Player, p2:Player, fruitons:GameState.Fruitons) {
        this.currentState = new GameState([p1, p2], 0, fruitons);
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
        var validActions:ArrayOfEquitables<Action> = new IKernel.Actions();

        for (a in allActions) {
            // Do not return duplicate actions
            // Until we have a hash set, we go quadratic
            if (validActions.contains(a)) {
                continue;
            }

            // Check validity
            var newState:GameState = currentState.clone();
            if (a.execute(newState).isValid) {
                validActions.push(a);
            }
        }

        return validActions;
    }

    public function performAction(userAction:Action):IKernel.Events {
        if (userAction == null) {
            throw new InvalidActionException("Null action");
        }

        var actions:ActionStack = new ActionStack();
        var eventBuffer:IKernel.Events = new IKernel.Events();
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

    // ==============
    // Helper methods
    // ==============
    function addActions(actions:ActionStack, newActions:ActionStack) {
        for (a in newActions) {
            actions.add(a);
        }
    }
}
