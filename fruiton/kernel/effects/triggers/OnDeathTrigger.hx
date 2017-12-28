package fruiton.kernel.effects.triggers;

import fruiton.kernel.exceptions.Exception;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.actions.AttackActionContext;

class OnDeathTrigger extends TargetableTrigger {

    public function new(fruitonId:Int, effect:Effect, targetPattern:TargetPattern) {
        super(fruitonId, effect, targetPattern);
    }

    override function onAfterBeingAttacked(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        var attackedFruiton = state.field.get(context.target).fruiton;
        // Am I dead?
        if (!attackedFruiton.isAlive) {
            triggerEffectOnTargets(context.target, state, result);
        }
    }

    override public function equalsTo(other:Effect):Bool {
        if (!Std.is(other, OnAttackTrigger)) {
            return false;
        }
        return super.equalsTo(other);
    }

    override public function getHashCode():Int {
        throw new Exception("OnDeathTrigger has not implemented hash code yet.");
    }

    override function clone():Effect {
        return new OnDeathTrigger(fruitonId, effect, targetPattern);
    }
}