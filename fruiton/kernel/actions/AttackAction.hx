package fruiton.kernel.actions;

import fruiton.kernel.events.AttackEvent;

class AttackAction extends GenericAction<AttackActionContext> {

    public function new(context:AttackActionContext) {
        super(context);
    }

    override function validate(state:GameState, context:AttackActionContext):Bool {
        var result:Bool =
            context != null &&
            context.source != null &&
            state.field.exists(context.source) &&
            context.target != null &&
            state.field.exists(context.target) &&
            state.turnState.attackCount > 0;

        if (!result) {
            return false;
        }

        var sourceFruiton:Fruiton = state.field.get(context.source).fruiton;
        var targetFruiton:Fruiton = state.field.get(context.target).fruiton;

        result = result &&
            sourceFruiton != null &&
            sourceFruiton.owner != null &&
            sourceFruiton.owner.equals(state.activePlayer) &&
            targetFruiton != null &&
            targetFruiton.owner != null &&
            !targetFruiton.owner.equals(state.activePlayer);

        return result;
    }

    override function executeImpl(state:GameState, result:ActionExecutionResult) {
        var newContext:AttackActionContext = actionContext.clone();
        var targetFruion:Fruiton = state.field.get(newContext.target).fruiton;

        if (result.isValid) {
            targetFruion.onBeforeAttack(newContext, state, result);
        }
        if (result.isValid) {
            attackFruiton(targetFruion, newContext, state, result);
        }
        if (result.isValid) {
            targetFruion.onAfterAttack(newContext, state, result);
        }
    }

    function attackFruiton(fruiton:Fruiton, context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        fruiton.takeDamage(context.damage);
        result.events.push(new AttackEvent(1, context.source, context.target, context.damage));
    }

    override public function toString():String {
        return super.toString() + " AttackAction:" + Std.string(actionContext);
    }

    override public function equalsTo(other:Action):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, AttackAction)) {
            return false;
        }

        var otherAttack = cast(other, AttackAction);
        return
            (this.actionContext == otherAttack.actionContext) ||
            (this.actionContext != null && this.actionContext.equalsTo(otherAttack.actionContext));
    }
}