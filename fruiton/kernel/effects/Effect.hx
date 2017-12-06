package fruiton.kernel.effects;

import fruiton.kernel.actions.EndTurnActionContext;
import fruiton.kernel.effects.contexts.EffectContext;
import fruiton.kernel.actions.MoveActionContext;
import fruiton.kernel.actions.AttackActionContext;

class Effect implements IGameEventHandler  implements IAbstractClass implements IEquitable<Effect> implements IHashable {

    public var name(default, null):String;

    function new(){
        name = Type.getClassName(Type.getClass(this));
    }

    public function onBeforeEffectAdded(context: EffectContext, state: GameState, result:ActionExecutionResult) {
        trace("onBeforeEffectAdded Effect: " + name + ">" + context.effect.name);
    }

    public function onAfterEffectAdded(context: EffectContext, state: GameState, result:ActionExecutionResult) {
        trace("onAfterEffectAdded Effect: " + name + ">" + context.effect.name);
    }

    public function onBeforeEffectRemoved(context: EffectContext, state: GameState, result:ActionExecutionResult) {
        trace("onBeforeEffectRemoved Effect: " + name + ">" + context.effect.name);
    }

    public function onAfterEffectRemoved(context: EffectContext, state: GameState, result:ActionExecutionResult) {
        trace("onAfterEffectRemoved Effect: " + name + ">" + context.effect.name);
    }

    public function onBeforeTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeTurnEnd Effect: " + name + " " + context);
    }

    public function onAfterTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterTurnEnd Effect: " + name + " " + context);
    }

    public function onBeforeMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeMove Effect: " + name + " " + context);
    }

    public function onAfterMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterMove Effect: " + name + " " + context);
    }

    public function onBeforeAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeAttack Effect: " + name + " " + context);
    }

    public function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterAttack Effect: " + name + " " + context);
    }

    public function onBeforeBeingAttacked(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onBeforeAttack Effect: " + name + " " + context);
    }

    public function onAfterBeingAttacked(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        trace("onAfterAttack Effect: " + name + " " + context);
    }

    public function getHashCode(): Int;

    public function equalsTo(other:Effect): Bool;

    public function tryAddEffect(context: EffectContext, state: GameState, result:ActionExecutionResult) : Bool {
        return true;
    }

    public function tryRemoveEffect(context: EffectContext, state: GameState, result:ActionExecutionResult) : Bool {
        return true;
    }
 }