package fruiton.kernel.actions;

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
            sourceFruiton.owner.equals(state.activePlayer) &&
            targetFruiton != null &&
            targetFruiton.owner != null &&
            !targetFruiton.owner.equals(state.activePlayer) &&
            (state.turnState.actionPerformer == null ||
            sourceFruiton.equalsId(state.turnState.actionPerformer));

        return result;
    }

    override function executeImpl(state:GameState, result:ActionExecutionResult) {
        var newContext:EffectActionContext = actionContext.clone();
        var sourceFruiton:Fruiton = state.field.get(newContext.target).fruiton;

        if (result.isValid) {
            sourceFruiton.onBeforeEffectAdded(newContext, state, result);
        }
        if (result.isValid) {
            sourceFruiton.addEffect(newContext.effect);
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