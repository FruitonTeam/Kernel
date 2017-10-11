package fruiton.kernel.effects;

import fruiton.kernel.actions.EndTurnActionContext;
import fruiton.kernel.actions.MoveActionContext;
import fruiton.kernel.actions.AttackActionContext;

class Effect implements IGameEventHandler  implements IAbstractClass implements IEquitable<Effect> {

    public var name(default, null): String = "";

    var owner: Fruiton;

    function new(owner:Fruiton){
        this.owner = owner;
    }

    public function onBeforeEffectAdded(target:Fruiton, effect:Effect, state: GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeEffectAdded Effect: " + name + ">" + effect.name);
    }

    public function onAfterEffectAdded(target:Fruiton, effect:Effect, state: GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterEffectAdded Effect: " + name + ">" + effect.name);
    }

    public function onBeforeEffectRemoved(target:Fruiton, effect:Effect, state: GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeEffectRemoved Effect: " + name + ">" + effect.name);
    }

    public function onAfterEffectRemoved(target:Fruiton, effect:Effect, state: GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterEffectRemoved Effect: " + name + ">" + effect.name);
    }

    public function onBeforeTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeTurnEnd Effect: " + name + " " + context);
    }

    public function onAfterTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterTurnEnd Effect: " + name + " " + context);
    }

    public function onBeforeMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeMove Effect: " + name + " " + context);
    }

    public function onAfterMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterMove Effect: " + name + " " + context);
    }

    public function onBeforeAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeAttack Effect: " + name + " " + context);
    }

    public function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterAttack Effect: " + name + " " + context);
    }

    public function equalsTo(other:Effect):Bool;
}