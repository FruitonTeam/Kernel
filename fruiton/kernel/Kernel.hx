package fruiton.kernel;

import fruiton.kernel.exceptions.InvalidActionException;
import haxe.ds.GenericStack;

class Kernel implements IKernel {

	var currentState:GameState;
	var eventBuffer:Array<Event>;
	var actions:GenericStack<Action>;

	public function new() {
		this.currentState = new GameState();
		this.actions = new GenericStack<Action>();
	}

	public function getAllValidActions():Array<Action> {
		return [];
	}

    public function performAction(userAction:Action):Array<Event> {
		if (userAction == null) {
			throw new InvalidActionException("Null action");
		}
		eventBuffer = [];
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
					throw new InvalidActionException(currentAction.toString());
				}
			}
			if (currentState.winner != GameState.NONE) {
				eventBuffer = eventBuffer.concat(finishGame());
				break;
			}
		}

		currentState.nextTurn();

		return eventBuffer;
	}

	function finishGame():Array<Event> {
		return [];
	}

	// ==============
	// Helper methods
	// ==============
	function addActions(newActions:GenericStack<Action>) {
		for (a in newActions) {
			actions.add(a);
		}
	}
}
