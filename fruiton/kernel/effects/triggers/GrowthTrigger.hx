package fruiton.kernel.effects.triggers;

import fruiton.kernel.actions.AttackActionContext;
import fruiton.kernel.actions.HealActionContext;
import fruiton.kernel.actions.MoveActionContext;
import fruiton.kernel.actions.TargetableActionContext;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.dataStructures.Vector2;

class GrowthTrigger extends TargetableTrigger {

    // In this context, this field counts all the moves, attacks and heals of the fruiton.
    var moves:Int;
    // The number of moves, attacks, heals that have to be performed before triggering the effect.
    var triggerMovesNumber:Int;

    public function new(effect:Effect, targetPattern:TargetPattern, triggerMovesNumber:Int, moves:Int = 0) {
        super(effect, targetPattern);
        this.triggerMovesNumber = triggerMovesNumber;
        this.moves = moves;
    }

    override function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        increaseMoves(context.source, state, result);
    }

    override function onAfterHeal(context:HealActionContext, state:GameState, result:ActionExecutionResult) {
        increaseMoves(context.source, state, result);
    }

    override function onAfterMove(context:MoveActionContext, state:GameState, result:ActionExecutionResult) {
        increaseMoves(context.target, state, result);
    }

    function increaseMoves(origin:Vector2, state:GameState, result:ActionExecutionResult) {
        moves = moves + 1;
        if (moves == triggerMovesNumber) {
            triggerEffectOnTargets(origin, state, result);
        }
    }

    override public function equalsTo(other:Effect):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, GrowthTrigger)) {
            return false;
        }

        var otherEffect = cast(other, GrowthTrigger);

        return this.effect.equalsTo(otherEffect.effect) &&
        moves == otherEffect.moves;
    }

    override public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 + effect.getHashCode();
        return hash;
    }

    override function clone():Effect {
        return new GrowthTrigger(effect, targetPattern, triggerMovesNumber, moves);
    }
}