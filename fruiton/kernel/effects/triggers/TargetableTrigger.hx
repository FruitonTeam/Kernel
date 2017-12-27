package fruiton.kernel.effects.triggers;

import fruiton.dataStructures.Vector2;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.effects.contexts.EffectContext;

class TargetableTrigger extends Trigger {

    var targetPattern:TargetPattern;

    function new(fruitonId:Int, effect:Effect, targetPattern:TargetPattern) {
        super(fruitonId, effect);
        this.targetPattern = targetPattern;
    }

    function triggerEffectOnTargets(origin:Vector2, state:GameState, result:ActionExecutionResult) {
        // Refresh inner effect's id.
        effect.fruitonId = fruitonId;
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

    override public function equalsTo(other:Effect):Bool {
        if (!Std.is(other, TargetableTrigger)) {
            return false;
        }
        var otherEffect = cast(other, TargetableTrigger);
        return otherEffect.targetPattern.equalsTo(targetPattern);
    }
}