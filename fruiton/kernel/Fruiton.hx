package fruiton.kernel;

import fruiton.kernel.actions.MoveActionContext;
import fruiton.dataStructures.collections.ReadOnlyArray;

typedef MoveGenerators = Array<MoveGenerator>;
typedef ROMoveGenerators = ReadOnlyArray<MoveGenerator>;

class Fruiton {

    public var id(default, null):Int;
    public var position(default, null):Position;
    public var owner(default, null):Player;

    /**
     *  Base set of move patterns for this fruiton.
     *  More patterns may be added (or removed) by effects but this set should remain unmodified.
     */
    var moveGenerators:ROMoveGenerators;

    public function new(id:Int, position:Position, owner:Player, generators:MoveGenerators) {
        this.id = id;
        this.position = position;
        this.owner = owner;
        this.moveGenerators = new ROMoveGenerators(generators);
    }

    public function clone():Fruiton {
        // Player is no cloned to remain the same as in GameState
        return new Fruiton(this.id, this.position.clone(), this.owner, this.moveGenerators.shallowCopyToArray());
    }

    public function getAllActions(state:GameState):IKernel.Actions {
        var allActions:IKernel.Actions = new IKernel.Actions();
        
        // Move actions
        for (pattern in moveGenerators) {
            var moveActions:MoveGenerator.Moves = pattern.getMoves(position);
            // In a world without covariant interfaces...
            for (move in moveActions) {
                allActions.push(move);
            }
        }

        return allActions;
    }

    // ==============
    // Event handlers
    // ==============
    public function onBeforeMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeMove Fruiton: " + id + " Context: " + context);
    }

    public function onAfterMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterMove Fruiton: " + id + " Context: " + context);
    }

    public function moveTo(newPosition:Position) {
        position = newPosition;
    }

    public function toString():String {
        return "Fruiton Id: " + id + " Position: " + Std.string(position);
    }
}