package fruiton.kernel.actions;

import fruiton.IAbstractClass;
import fruiton.IEquitable;

class ActionContext implements IAbstractClass implements IEquitable<ActionContext> {

    // Private constructor to allow abstract class
    function new() {

    }

    public function equalsTo(other:ActionContext):Bool;
}