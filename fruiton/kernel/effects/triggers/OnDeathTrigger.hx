package fruiton.kernel.effects.triggers;

import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.actions.AttackActionContext;

class OnDeathTrigger extends TargetableTrigger {

    public function new(effect:Effect, targetPattern:TargetPattern) {
        super(effect, targetPattern);
    }

    override function onAfterBeingAttacked(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        var attackedFruiton = state.field.get(context.target).fruiton;
        // Am I dead?
        if (!attackedFruiton.isAlive) {
            TriggerEffectOnTargets(context.target, state, result);
        }
    }

    override public function equalsTo(other:Effect):Bool {
        return true;
    }

    override public function getHashCode():Int {
        return 0;
    }
}