package fruiton.kernel.actions;

import fruiton.kernel.events.AttackEvent;

class AttackAction extends TargetableAction<AttackActionContext> {

    public static inline var ID:Int = 0;

    public function new(context:AttackActionContext) {
        super(context);
    }

    override function validate(state:GameState, context:AttackActionContext):Bool {
        var result:Bool =
            super.validate(state, context) &&
            context != null &&
            context.source != null &&
            state.field.exists(context.source) &&
            context.target != null &&
            state.field.exists(context.target) &&
            state.turnState.abilitiesCount > 0 &&
            !state.turnState.usedAbility;

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
            !targetFruiton.owner.equals(state.activePlayer) &&
            (state.turnState.actionPerformer == null ||
            sourceFruiton.equalsId(state.turnState.actionPerformer)) &&
            sourceFruiton.currentAttributes.damage == actionContext.damage;

        return result;
    }

    override function executeImpl(state:GameState, result:ActionExecutionResult) {
        var newContext:AttackActionContext = actionContext.clone();
        var targetFruiton:Fruiton = state.field.get(newContext.target).fruiton;
        var attackingFruiton:Fruiton = state.field.get(newContext.source).fruiton;

        if (result.isValid) {
            attackingFruiton.onBeforeAttack(newContext, state, result);
        }
        if (result.isValid) {
            targetFruiton.onBeforeBeingAttacked(newContext, state, result);
        }
        if (result.isValid) {
            attackFruiton(targetFruiton, newContext, state, result);
        }
        if (result.isValid) {
            attackingFruiton.onAfterAttack(newContext, state, result);
        }
        if (result.isValid) {
            targetFruiton.onAfterBeingAttacked(newContext, state, result);
        }
    }

    function attackFruiton(fruiton:Fruiton, context:AttackActionContext, state:GameState, result:ActionExecutionResult) {
        state.turnState.abilitiesCount--;
        state.turnState.usedAbility = true;
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

    override public function getId():Int {
        return ID;
    }

    override public function toUniqueString():String {
        return Std.string(ID) + Std.string(actionContext.source) + Std.string(actionContext.target) + Std.string(actionContext.damage);
    }
}