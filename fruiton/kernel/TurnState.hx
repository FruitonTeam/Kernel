package fruiton.kernel;

class TurnState {

    public var actionPerformer(default, default):Fruiton;
    public var moveCount(default, default):Int;
    public var attackCount(default, default):Int;
    public var didAttack(default, default):Bool;
    public var endTime(default, default):Float;

    public function new() {
        this.actionPerformer = null;
        this.moveCount = 1;
        this.attackCount = 1;
        this.didAttack = false;
        this.endTime = Sys.time() + Kernel.turnTimeLimit;
    }

    public function clone():TurnState {
        var newState:TurnState = new TurnState();
        newState.actionPerformer = this.actionPerformer;
        newState.moveCount = this.moveCount;
        newState.attackCount = this.attackCount;
        newState.didAttack = this.didAttack;
        newState.endTime = this.endTime;

        return newState;
    }

    public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;
        var p2 = HashHelper.PRIME_0;
        var p3 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        if (actionPerformer != null) {
            hash  = hash * p1 +  actionPerformer.getHashCode();
        }
        if (didAttack) {
            hash  = hash * p1 +  p2;
        } else {
            hash  = hash * p1 +  p3;
        }
        hash = hash * p1 +  moveCount;
        hash = hash * p1 +  attackCount;
        return hash;
    }
}