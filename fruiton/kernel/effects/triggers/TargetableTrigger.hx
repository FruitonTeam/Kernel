package fruiton.kernel.effects.triggers;

import fruiton.dataStructures.Vector2;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.effects.contexts.EffectContext;
import haxe.Serializer;
import haxe.Unserializer;

class TargetableTrigger extends Trigger {

    var targetPattern:TargetPattern;

    @:keep
    override function hxSerialize(s:Serializer) {
        super.hxSerialize(s);
        s.serialize(targetPattern);
    }

    @:keep
    override function hxUnserialize(u:Unserializer) {
        super.hxUnserialize(u);
        targetPattern = u.unserialize();
    }

    function new(fruitonId:Int, effect:Effect, targetPattern:TargetPattern, text:String = "") {
        super(fruitonId, effect, text);
        this.targetPattern = targetPattern;
    }

    function triggerEffectOnTargets(origin:Vector2, state:GameState, result:ActionExecutionResult) {
        var targets:Targets = targetPattern.getTargets(origin);
        for (target in targets) {
            if (!state.field.exists(target)) continue;
            var targetFruiton = state.field.get(target).fruiton;
            if (targetFruiton == null) continue;
            effect.fruitonId = targetFruiton.id;
            if (targetFruiton != null) {
                var effectContext = new EffectContext(
                    effect,
                    target
                );
                targetFruiton.addEffect(effect.clone(), effectContext, state, result);
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