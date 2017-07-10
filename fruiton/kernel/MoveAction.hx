package fruiton.kernel;

class MoveAction extends Action {
    
    public var source(default, null):Tile;
    public var target(default, null):Tile;

    public function new(source:Tile, target:Tile) {
        super();
        this.source = source;
        this.target = target;
    }

    function validate() {
        isValid = 
            source != null && 
            source.fruiton != null && 
            target != null;
    }

    override public function execute(state:GameState):Bool {
        validate();
        
        result = new ActionExecutionResult();

        // Following may be while cycle through delegates
        if (isValid) {
            source.fruiton.onBeforeMove(this, state);
        }
        if (isValid) {
            source.fruiton.onAfterMove(this, state);
        }

        return isValid;
    }

    override public function toString():String {
        return super.toString() + " source: ... target: ...";
    }
}
