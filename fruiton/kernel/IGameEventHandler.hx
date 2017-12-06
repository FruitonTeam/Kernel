package fruiton.kernel;

import fruiton.kernel.actions.MoveActionContext;
import fruiton.kernel.actions.EndTurnActionContext;
import fruiton.kernel.effects.contexts.EffectContext;
import fruiton.kernel.actions.AttackActionContext;

interface IGameEventHandler {

    function onBeforeEffectAdded(context: EffectContext, state: GameState, result:ActionExecutionResult): Void;
    function onAfterEffectAdded(context: EffectContext, state: GameState, result:ActionExecutionResult): Void;
    function onBeforeEffectRemoved(context: EffectContext, state: GameState, result:ActionExecutionResult): Void;
    function onAfterEffectRemoved(context: EffectContext, state: GameState, result:ActionExecutionResult): Void;
    function onBeforeTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult):Void;
    function onAfterTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult):Void;
    function onBeforeMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult): Void;
    function onAfterMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult): Void;
    function onBeforeAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult): Void;
    function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult): Void;
    function onBeforeBeingAttacked(context:AttackActionContext, state:GameState, result:ActionExecutionResult): Void;
    function onAfterBeingAttacked(context:AttackActionContext, state:GameState, result:ActionExecutionResult): Void;
}