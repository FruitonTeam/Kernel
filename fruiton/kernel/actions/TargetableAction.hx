package fruiton.kernel.actions;

class TargetableAction<TContext:(TargetableActionContext)> extends GenericAction<TContext> {

    function new(context:TContext) {
        super (context);
    }

    public function getContext():TargetableActionContext {
        return actionContext;
    }
}