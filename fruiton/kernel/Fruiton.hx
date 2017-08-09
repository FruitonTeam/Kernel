package fruiton.kernel;

import fruiton.kernel.actions.MoveActionContext;
import fruiton.kernel.actions.EndTurnActionContext;
import fruiton.kernel.actions.AttackActionContext;
import fruiton.kernel.events.DeathEvent;
import fruiton.dataStructures.Vector2;
import fruiton.dataStructures.collections.ExtendedArray;
import fruiton.kernel.actions.Action;

typedef MoveGenerators = Array<MoveGenerator>;
typedef AttackGenerators = Array<AttackGenerator>;

class Fruiton {

    public var id(default, null):Int;
    public var position(default, null):Vector2;
    public var owner(default, null):Player;
    public var hp(default, null):Int;

    public var isAlive(get, never):Bool;
    function get_isAlive():Bool {
        return hp > 0;
    }

    var moveGenerators:MoveGenerators;
    var attackGenerators:AttackGenerators;

    public function new(id:Int, position:Vector2, owner:Player, hp:Int, moves:MoveGenerators, attacks:AttackGenerators) {
        this.id = id;
        this.position = position;
        this.owner = owner;
        this.moveGenerators = moves.copy();
        this.attackGenerators = attacks.copy();
        this.hp = hp;
    }

    public function clone():Fruiton {
        // Player is no cloned to remain the same as in GameState
        return new Fruiton(this.id, this.position.clone(), this.owner, this.hp, this.moveGenerators, this.attackGenerators);
    }

    public function getAllActions(state:GameState):IKernel.Actions {
        var allActions:ExtendedArray<Action> = new IKernel.Actions();

        if (!isAlive) {
            return allActions;
        }

        // Move actions
        for (moveGen in moveGenerators) {
            allActions.pushAll(moveGen.getMoves(position));
        }

        // Attack actions
        for (attackGen in attackGenerators) {
            allActions.pushAll(attackGen.getAttacks(position));
        }

        return allActions;
    }

    public function takeDamage(damage:Int) {
        hp -= damage;
    }

    public function moveTo(newPosition:Vector2) {
        position = newPosition;
    }

    // ==============
    // Event handlers
    // ==============
    public function onBeforeTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeTurnEnd Fruiton: " + id + " " + context);
    }

    public function onAfterTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterTurnEnd Fruiton: " + id + " " + context);
    }

    public function onBeforeMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeMove Fruiton: " + id + " " + context);
    }

    public function onAfterMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterMove Fruiton: " + id + " " + context);
    }

    public function onBeforeAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeAttack Fruiton: " + id + " " + context);
    }

    public function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterAttack Fruiton: " + id + " " + context);
        if (!isAlive) {
            state.field.get(position).fruiton = null;
            result.events.push(new DeathEvent(1, position));
        }
    }

    public function toString():String {
        return "Fruiton Id: " + id + " Position: " + Std.string(position);
    }
}