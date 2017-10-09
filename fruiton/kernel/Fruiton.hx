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

class Fruiton implements IHashable {

    public var id(default, null):Int;
    public var position(default, null):Vector2;
    public var owner(default, null):Player;
    public var hp(default, null):Int;
    public var model(default, null):String;
    public var type(default, null):Int;

    public static var KING_TYPE(default, never):Int = 1;
    public static var MAJOR_TYPE(default, never):Int = 2;
    public static var MINOR_TYPE(default, never):Int = 3;

    public var isKing(get, never):Bool;
    function get_isKing():Bool {
        return type == KING_TYPE;
    }

    public var isAlive(get, never):Bool;
    function get_isAlive():Bool {
        return hp > 0;
    }

    var moveGenerators:MoveGenerators;
    var attackGenerators:AttackGenerators;

    public function new(id:Int, position:Vector2, owner:Player, hp:Int, model:String, moves:MoveGenerators, attacks:AttackGenerators, type:Int) {
        this.id = id;
        this.position = position;
        this.owner = owner;
        this.moveGenerators = moves.copy();
        this.attackGenerators = attacks.copy();
        this.hp = hp;
        this.model = model;
        this.type = type;
    }

    public function clone():Fruiton {
        // Player is no cloned to remain the same as in GameState
        return new Fruiton(this.id, this.position.clone(), this.owner, this.hp, this.model, this.moveGenerators, this.attackGenerators, this.type);
    }

    public function equalsId(other:Fruiton):Bool {
        return this.id == other.id;
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
            if (isKing) {
                state.losers.push(owner.id);
            }
        }
    }

    public function toString():String {
        return "Fruiton Id: " + id + " Position: " + Std.string(position);
    }

    public function getHashCode():Int {
        var p0 = HashHelper.getPrime(5);
        var p1 = HashHelper.getPrime(6);

        var hash = p0;
        hash = hash * p1 +  id;
        hash = hash * p1 +  position.getHashCode();
        hash = hash * p1 +  owner.getHashCode();
        hash = hash * p1 +  hp;
        hash = hash * p1 +  type;
        hash = hash * p1 + HashHelper.hashString(model);
        hash = hash * p1 + HashHelper.hashIterable(moveGenerators, 7, 8);
        hash = hash * p1 + HashHelper.hashIterable(attackGenerators, 8, 9);
        return hash;
    }
}