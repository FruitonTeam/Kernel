package fruiton.kernel.actions;

class TargetableAction<TContext:(TargetableActionContext)> extends GenericAction<TContext> {

    public static var ID:Int = 13;

    function new(context:TContext) {
        super (context);
    }

    public function getContext():TargetableActionContext {
        return actionContext;
    }
}