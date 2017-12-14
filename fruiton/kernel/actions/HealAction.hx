package fruiton.kernel.actions;

import fruiton.kernel.events.HealEvent;

class HealAction extends TargetableAction<HealActionContext> {

    public static inline var ID:Int = 3;

    public function new(context:HealActionContext) {
        super(context);
    }

    override function validate(state:GameState, context:HealActionContext):Bool {
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
            targetFruiton.currentAttributes.hp < targetFruiton.originalAttributes.hp &&
            targetFruiton.owner != null &&
            targetFruiton.owner.equals(state.activePlayer) &&
            (state.turnState.actionPerformer == null ||
            sourceFruiton.equalsId(state.turnState.actionPerformer)) &&
            sourceFruiton.currentAttributes.heal == actionContext.heal;

        return result;
    }

    override function executeImpl(state:GameState, result:ActionExecutionResult) {
        var newContext:HealActionContext = actionContext.clone();
        var targetFruiton:Fruiton = state.field.get(newContext.target).fruiton;
        var attackingFruiton:Fruiton = state.field.get(newContext.source).fruiton;

        if (result.isValid) {
            attackingFruiton.onBeforeHeal(newContext, state, result);
        }
        if (result.isValid) {
            targetFruiton.onBeforeBeingHealed(newContext, state, result);
        }
        if (result.isValid) {
            healFruiton(targetFruiton, newContext, state, result);
        }
        if (result.isValid) {
            attackingFruiton.onAfterHeal(newContext, state, result);
        }
        if (result.isValid) {
            targetFruiton.onAfterBeingHealed(newContext, state, result);
        }
    }

    function healFruiton(fruiton:Fruiton, context:HealActionContext, state:GameState, result:ActionExecutionResult) {
        state.turnState.abilitiesCount--;
        state.turnState.usedAbility = true;
        fruiton.receiveHeal(context.heal);
        result.events.push(new HealEvent(1, context.source, context.target, context.heal));
    }

    override public function equalsTo(other:Action):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, HealAction)) {
            return false;
        }

        var otherHeal = cast(other, HealAction);
        return
            (this.actionContext == otherHeal.actionContext) ||
            (this.actionContext != null && this.actionContext.equalsTo(otherHeal.actionContext));
    }

    override public function getId():Int {
        return ID;
    }

    override public function toUniqueString():String {
        return Std.string(ID) + Std.string(actionContext.source) + Std.string(actionContext.target) + Std.string(actionContext.heal);
    }

    override public function toString():String {
        return super.toString() + " HealAction:" + Std.string(actionContext);
    }
}