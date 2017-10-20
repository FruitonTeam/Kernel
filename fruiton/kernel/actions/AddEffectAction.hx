package fruiton.kernel.actions;

import fruiton.kernel.events.AddEffectEvent;

class AddEffectAction extends GenericAction<EffectActionContext> {

    public static inline var ID:Int = 3;
    var ignoreTime: Bool;

    public function new(context:EffectActionContext, ignoreTime: Bool) {
        super(context);
        this.ignoreTime = ignoreTime;
    }

    override function validate(state:GameState, context:EffectActionContext):Bool {
        var result:Bool =
            (ignoreTime || super.validate(state, context)) &&
            context != null &&
            context.source != null &&
            state.field.exists(context.source) &&
            context.target != null &&
            state.field.exists(context.target);

        if (!result) {
            return false;
        }

        var sourceFruiton:Fruiton = state.field.get(context.source).fruiton;
        var targetFruiton:Fruiton = state.field.get(context.target).fruiton;

        result =
            sourceFruiton != null &&
            sourceFruiton.owner != null &&
            targetFruiton != null &&
            targetFruiton.owner != null;
        return result;
    }

    override function executeImpl(state:GameState, result:ActionExecutionResult) {
        var newContext:EffectActionContext = actionContext.clone();
        var sourceFruiton:Fruiton = state.field.get(newContext.target).fruiton;

        if (result.isValid) {
            sourceFruiton.onBeforeEffectAdded(newContext, state, result);
        }
        if (result.isValid && !newContext.gameStarted) {
            sourceFruiton.addEffect(newContext.effect);
            result.events.push(new AddEffectEvent(1, newContext.source, newContext.target, newContext.effect.name));
        }
        if (result.isValid) {
            sourceFruiton.onAfterEffectAdded(newContext, state, result);
        }
    }

    override public function toString():String {
        return super.toString() + " AddEffectAction:" + Std.string(actionContext);
    }

    override public function equalsTo(other:Action):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, AddEffectAction)) {
            return false;
        }

        var otherAddEffect = cast(other, AddEffectAction);
        return
            (this.actionContext == otherAddEffect.actionContext) ||
            (this.actionContext != null && this.actionContext.equalsTo(otherAddEffect.actionContext));
    }

    override public function getId():Int {
        return ID;
    }
}