package fruiton.kernel;

import fruiton.kernel.actions.MoveActionContext;
import fruiton.kernel.actions.EndTurnActionContext;
import fruiton.kernel.effects.contexts.EffectContext;
import fruiton.kernel.actions.AttackActionContext;
import fruiton.kernel.actions.HealActionContext;
import fruiton.kernel.events.DeathEvent;
import fruiton.kernel.effects.Effect;
import fruiton.dataStructures.Vector2;
import fruiton.dataStructures.collections.ExtendedArray;
import fruiton.kernel.actions.Action;
import fruiton.dataStructures.FruitonAttributes;
import fruiton.kernel.abilities.Ability;
import fruiton.kernel.events.HealEvent;
import fruiton.kernel.events.AttackEvent;
import haxe.Serializer;
import haxe.Unserializer;

typedef MoveGenerators = Array<MoveGenerator>;
typedef AttackGenerators = Array<AttackGenerator>;
typedef Abilities = Array<Ability>;
typedef Effects = Array<Effect>;

class Fruiton implements IHashable implements IGameEventHandler {

    public var dbId(default, null):Int;
    public var originalAttributes:FruitonAttributes;
    public var currentAttributes:FruitonAttributes;
    public var id(default, default):Int;
    public var name(default, null):String;
    public var position(default, null):Vector2;
    public var owner(default, null):Player;
    public var model(default, null):String;
    public var type(default, null):Int;
    public var effects(default, null):Effects;

    public static var KING_TYPE(default, never):Int = 1;
    public static var MAJOR_TYPE(default, never):Int = 2;
    public static var MINOR_TYPE(default, never):Int = 3;

    public var isKing(get, never):Bool;

    function get_isKing():Bool {
        return type == KING_TYPE;
    }

    public var isAlive(get, never):Bool;

    function get_isAlive():Bool {
        return currentAttributes.hp > 0;
    }

    var moveGenerators:MoveGenerators;
    var attackGenerators:AttackGenerators;
    var abilities:Abilities;

    @:keep
    function hxSerialize(s:Serializer) {
        Serializer.USE_CACHE = true;
        s.serialize(dbId);
        s.serialize(originalAttributes);
        s.serialize(currentAttributes);
        s.serialize(id);
        s.serialize(name);
        s.serialize(position);
        s.serialize(owner);
        s.serialize(model);
        s.serialize(type);
        s.serialize(effects);
        s.serialize(moveGenerators);
        s.serialize(attackGenerators);
        s.serialize(abilities);
    }

    @:keep
    function hxUnserialize(u:Unserializer) {
        dbId = u.unserialize();
        originalAttributes = u.unserialize();
        currentAttributes = u.unserialize();
        id = u.unserialize();
        name = u.unserialize();
        position = u.unserialize();
        owner = u.unserialize();
        model = u.unserialize();
        type = u.unserialize();
        effects = u.unserialize();
        moveGenerators = u.unserialize();
        attackGenerators = u.unserialize();
        abilities = u.unserialize();
    }

    public function new(
        dbId:Int,
        id:Int,
        name:String,
        position:Vector2,
        owner:Player,
        model:String,
        moves:MoveGenerators,
        attacks:AttackGenerators,
        effects:Effects,
        type:Int,
        originalAttributes:FruitonAttributes,
        ?currentAttributes:FruitonAttributes,
        ?abilities:Abilities
    ) {
        this.dbId = dbId;
        this.id = id;
        this.name = name;
        this.position = position;
        this.owner = owner;
        this.moveGenerators = moves.copy();
        this.attackGenerators = attacks.copy();
        this.effects = effects.copy();
        this.model = model;
        this.type = type;
        this.originalAttributes = originalAttributes.clone();
        this.currentAttributes = (currentAttributes == null) ? originalAttributes.clone() : currentAttributes.clone();
        this.abilities = (abilities == null) ? new Abilities() : abilities.copy();
    }

    public function applyEffectsOnGameStart(state: GameState) {
        // trigger add effect events on effects that are present in the game from the beggining
        for (effect in effects) {
            effect.fruitonId = id;
            effect.tryAddEffect (
                new EffectContext(
                    effect,
                    position
                ),
                state,
                new ActionExecutionResult()
            );
        }
    }

    public function clone():Fruiton {
        // Player is no cloned to remain the same as in GameState
        return new Fruiton(
            this.dbId,
            this.id,
            this.name,
            this.position.clone(),
            this.owner,
            this.model,
            this.moveGenerators,
            this.attackGenerators,
            [for (effect in this.effects) effect.clone()],
            this.type,
            this.originalAttributes.clone(),
            this.currentAttributes.clone(),
            this.abilities.copy()
        );
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
            allActions.pushAll(attackGen.getAttacks(position, currentAttributes.damage));
        }

        for (ability in abilities) {
            allActions.pushAll(ability.getActions(position, this));
        }

        return allActions;
    }

    public function takeDamage(dmg:Int, source:Vector2, target: Vector2, state:GameState, result:ActionExecutionResult) {
        currentAttributes.hp -= dmg;
        result.events.push(new AttackEvent(1, source, target, dmg));
    }

    public function receiveHeal(heal:Int, source:Vector2, target: Vector2, result:ActionExecutionResult) {
        currentAttributes.hp = cast Math.min(currentAttributes.hp + heal, originalAttributes.hp);
        result.events.push(new HealEvent(1, source, target, heal));
    }

    public function addEffect(effect:Effect, context:EffectContext, state:GameState, result:ActionExecutionResult) {
        var shouldAddEffect = effect.tryAddEffect(context, state, result);
        if (shouldAddEffect) {
            this.onBeforeEffectAdded(context, state, result);
            this.effects.push(effect);
            this.onAfterEffectAdded(context, state, result);
        }
    }

    public function removeEffect(effect:Effect) {
        effects.remove(effect);
    }

    public function moveTo(newPosition:Vector2) {
        position = newPosition;
    }

    public function isImmuneTo(actionId:Int):Bool {
        return currentAttributes.immunities.indexOf(actionId) != -1;
    }

    public function checkForDeath(state:GameState, result:ActionExecutionResult) {
        if (!isAlive) {
            state.field.get(position).fruiton = null;
            state.fruitons.remove(this);
            result.events.push(new DeathEvent(1, this));
        }
    }

    // ==============
    // Event handlers
    // ==============
    public function onBeforeEffectAdded(context:EffectContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeEffectAdded Fruiton: " + id + ">" + context.effect.name);
        for (effect in this.effects) {
            effect.onBeforeEffectAdded(context, state, result);
        }
    }

    public function onAfterEffectAdded(context:EffectContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterEffectAdded Fruiton: " + id + ">" + context.effect.name);
        for (effect in this.effects) {
            effect.onAfterEffectAdded(context, state, result);
        }
    }

    public function onBeforeEffectRemoved(context:EffectContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeEffectRemoved Fruiton: " + id + ">" + context.effect.name);
        for (effect in this.effects) {
            effect.onBeforeEffectRemoved(context, state, result);
        }
    }

    public function onAfterEffectRemoved(context:EffectContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterEffectRemoved Fruiton: " + id + ">" + context.effect.name);
        for (effect in this.effects) {
            effect.onAfterEffectRemoved(context, state, result);
        }
    }

    public function onBeforeTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeTurnEnd Fruiton: " + id + " " + context);
        for (effect in this.effects) {
            effect.onBeforeTurnEnd(context, state, result);
        }
    }

    public function onAfterTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterTurnEnd Fruiton: " + id + " " + context);
        for (effect in this.effects) {
            effect.onAfterTurnEnd(context, state, result);
        }
    }

    public function onBeforeMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeMove Fruiton: " + id + " " + context);
        for (effect in this.effects) {
            effect.onBeforeMove(context, state, result);
        }
    }

    public function onAfterMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterMove Fruiton: " + id + " " + context);
        for (effect in this.effects) {
            effect.onAfterMove(context, state, result);
        }
    }

    public function onBeforeAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeAttack Fruiton: " + id + " " + context);
        for (effect in this.effects) {
            effect.onBeforeAttack(context, state, result);
        }
    }

    public function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterAttack Fruiton: " + id + " " + context);
        for (effect in effects) {
            effect.onAfterAttack(context, state, result);
        }
    }

    public function onBeforeBeingAttacked(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeBeingAttacked Fruiton: " + id + " " + context);
        for (effect in effects) {
            effect.onBeforeBeingAttacked(context, state, result);
        }
    }

    public function onAfterBeingAttacked(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterBeingAttacked Fruiton: " + id + " " + context);
        for (effect in effects) {
            effect.onAfterBeingAttacked(context, state, result);
        }
        checkForDeath(state, result);
    }

    public function onBeforeHeal(context:HealActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeHeal Fruiton: " + id + " " + context);
        for (effect in this.effects) {
            effect.onBeforeHeal(context, state, result);
        }
    }

    public function onAfterHeal(context:HealActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterAttack Fruiton: " + id + " " + context);
        for (effect in effects) {
            effect.onAfterHeal(context, state, result);
        }
    }

    public function onBeforeBeingHealed(context:HealActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeBeingHealed Fruiton: " + id + " " + context);
        for (effect in effects) {
            effect.onBeforeBeingHealed(context, state, result);
        }
    }

    public function onAfterBeingHealed(context:HealActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterBeingHealed Fruiton: " + id + " " + context);
        for (effect in effects) {
            effect.onAfterBeingHealed(context, state, result);
        }
    }

    public function toString():String {
        return "Fruiton Id: " + id + " Position: " + Std.string(position);
    }

    public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 + id;
        hash = hash * p1 + position.getHashCode();
        hash = hash * p1 + owner.getHashCode();
        hash = hash * p1 + currentAttributes.hp;
        hash = hash * p1 + type;
        hash = hash * p1 + HashHelper.hashString(model);
        hash = hash * p1 + HashHelper.hashIterable(moveGenerators);
        hash = hash * p1 + HashHelper.hashIterable(effects);
        hash = hash * p1 + HashHelper.hashIterable(attackGenerators);
        hash = hash * p1 + currentAttributes.damage;
        return hash;
    }
}