package fruiton.kernel;

import fruiton.kernel.actions.MoveActionContext;
import fruiton.kernel.actions.EndTurnActionContext;
import fruiton.dataStructures.Vector2;

typedef MoveGenerators = Array<MoveGenerator>;

class Fruiton {

    public var id(default, null):Int;
    public var position(default, null):Vector2;
    public var owner(default, null):Player;

    var moveGenerators:MoveGenerators;

    public function new(id:Int, position:Vector2, owner:Player, generators:MoveGenerators) {
        this.id = id;
        this.position = position;
        this.owner = owner;
        this.moveGenerators = generators.copy();
    }

    public function clone():Fruiton {
        // Player is no cloned to remain the same as in GameState
        return new Fruiton(this.id, this.position.clone(), this.owner, this.moveGenerators.copy());
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
    public function onBeforeTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        //trace("onBeforeTurnEnd Fruiton: " + id + " " + context);
    }

    public function onAfterTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        //trace("onAfterTurnEnd Fruiton: " + id + " " + context);
    }

    public function onBeforeMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        //trace("onBeforeMove Fruiton: " + id + " " + context);
    }

    public function onAfterMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        //trace("onAfterMove Fruiton: " + id + " " + context);
    }

    public function moveTo(newPosition:Vector2) {
        position = newPosition;
    }

    public function toString():String {
        return "Fruiton Id: " + id + " Position: " + Std.string(position);
    }
}