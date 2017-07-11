package fruiton.kernel;

class TurnState {

    public var actionPerformer(default, default):Fruiton;
	public var moveCount(default, default):Int;
	public var attackCount(default, default):Int;

    public function new() {
        this.actionPerformer = null;
        this.moveCount = 1;
        this.attackCount = 1;
    }

    public function clone():TurnState {
        var newState:TurnState = new TurnState();
        newState.actionPerformer = this.actionPerformer;
        newState.moveCount = this.moveCount;
        newState.attackCount = this.attackCount;

        return newState;
    }
}