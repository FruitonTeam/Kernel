package fruiton.kernel.effects;

import fruiton.kernel.actions.EndTurnActionContext;
import fruiton.kernel.actions.AttackActionContext;
import fruiton.kernel.effects.contexts.EffectContext;

class DecayEffect extends Effect {

    public function new(fruitonId:Int, text:String = "") {
        super(fruitonId, text);
    }

    override function tryAddEffect(context: EffectContext, state: GameState, result:ActionExecutionResult) : Bool {
        var fruiton = state.findFruiton(fruitonId);
        return fruiton.effects.indexOf(context.effect) == -1;
    }

    override function onBeforeTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        var fruiton = state.findFruiton(fruitonId);
        fruiton.takeDamage(1, fruiton.position, fruiton.position, state, result);
    }

    override function onAfterTurnEnd(context:EndTurnActionContext, state:GameState, result:ActionExecutionResult) {
        var fruiton = state.findFruiton(fruitonId);
        if (fruiton != null) {
            fruiton.checkForDeath(state, result);
        }
    }

    override function onAfterAttack(context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        var targetFruiton = state.field.get(context.target).fruiton;
        var decayEffect = new DecayEffect(targetFruiton.id);
        var effectContext = new EffectContext(
            decayEffect,
            null
        );
        targetFruiton.addEffect(decayEffect, effectContext, state, result);
    }

    override public function equalsTo(other:Effect):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, DecayEffect)) {
            return false;
        }

        return true;
    }

    override public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        return hash;
    }

    override function clone():Effect {
        return new DecayEffect(fruitonId, text);
    }
}