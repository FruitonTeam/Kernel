package fruiton.kernel;

import fruiton.kernel.exceptions.InvalidActionException;
import fruiton.kernel.actions.Action;
import haxe.ds.GenericStack;

typedef ActionStack = GenericStack<Action>;

class Kernel implements IKernel {

	public var currentState(default, null):GameState;
	var eventBuffer:IKernel.Events;
	var actions:ActionStack;

	public function new(p1:Player, p2:Player, fruitons:GameState.Fruitons) {
		this.currentState = new GameState([p1, p2], 0, fruitons);
		this.actions = new ActionStack();
	}

	public function getAllValidActions():IKernel.Actions {
		return [];
	}

    public function performAction(userAction:Action):IKernel.Events {
		if (userAction == null) {
			throw new InvalidActionException("Null action");
		}
		
		eventBuffer = new IKernel.Events();
		actions.add(userAction);

		while (!actions.isEmpty()) {
			// Clone game state for transaction like execution
			var newState:GameState = currentState.clone();
			
			var currentAction:Action = actions.pop();
			var success:Bool = currentAction.execute(newState);
			if (success) {
				currentState = newState;
				addActions(currentAction.result.actions);
				eventBuffer = eventBuffer.concat(currentAction.result.events);
			} 
			else { // !success
				// Only user action cannot fail, other (generated) actions may fail silently
				if (currentAction == userAction) {
					throw new InvalidActionException(Std.string(currentAction));
				}
			}
			if (currentState.winner != GameState.NONE) {
				eventBuffer = eventBuffer.concat(finishGame());
				break;
			}
		}

		return eventBuffer;
	}

	function finishGame():IKernel.Events {
		return [];
	}

	// ==============
	// Helper methods
	// ==============
	function addActions(newActions:ActionStack) {
		for (a in newActions) {
			actions.add(a);
		}
	}
}
