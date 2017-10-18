package fruiton.kernel.effects;

import fruiton.kernel.actions.EndTurnActionContext;
import fruiton.kernel.actions.EffectActionContext;
import fruiton.kernel.actions.MoveActionContext;
import fruiton.kernel.actions.AttackActionContext;

class Effect implements IGameEventHandler  implements IAbstractClass implements IEquitable<Effect> {

    public var name(default, null): String = "";

    function new(){
    }

    public function onBeforeEffectAdded(context: EffectActionContext, state: GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeEffectAdded Effect: " + name + ">" + context.effect.name);
    }

    public function onAfterEffectAdded(context: EffectActionContext, state: GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterEffectAdded Effect: " + name + ">" + context.effect.name);
    }

    public function onBeforeEffectRemoved(context: EffectActionContext, state: GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeEffectRemoved Effect: " + name + ">" + context.effect.name);
    }

    public function onAfterEffectRemoved(context: EffectActionContext, state: GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterEffectRemoved Effect: " + name + ">" + context.effect.name);
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

    public function onBeforeBeingAttacked(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onBeforeAttack Effect: " + name + " " + context);
    }

    public function onAfterBeingAttacked(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        // Modify action and game state
        trace("onAfterAttack Effect: " + name + " " + context);
    }

    public function equalsTo(other:Effect): Bool;
}