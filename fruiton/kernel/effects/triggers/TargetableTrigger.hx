package fruiton.kernel.effects.triggers;

import fruiton.dataStructures.Vector2;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.effects.contexts.EffectContext;


class TargetableTrigger extends Trigger {

    var targetPattern:TargetPattern;

    function new(effect:Effect, targetPattern:TargetPattern) {
        super(effect);
        this.targetPattern = targetPattern;
    }

    private function TriggerEffectOnTargets(origin:Vector2, state:GameState, result:ActionExecutionResult) {
        var targets:Targets = targetPattern.getTargets(origin);
        for (target in targets) {
            var targetFruiton = state.field.get(target).fruiton;
            if (targetFruiton != null) {
                var effectContext = new EffectContext(
                    effect,
                    target
                );
                targetFruiton.addEffect(effect, effectContext, state, result);
            }
        }
    }
}