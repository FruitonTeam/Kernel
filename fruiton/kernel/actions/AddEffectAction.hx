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
            context.owner != null &&
            context.effect != null;

        return result;
    }

    override function executeImpl(state:GameState, result:ActionExecutionResult) {
        var newContext:EffectActionContext = actionContext.clone();

//        if (result.isValid) {
//            targetFruion.onBeforeAttack(newContext, state, result);
//        }
//        if (result.isValid) {
//            attackFruiton(targetFruion, newContext, state, result);
//        }
//        if (result.isValid) {
//            targetFruion.onAfterAttack(newContext, state, result);
//        }
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