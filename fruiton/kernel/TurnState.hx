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
        var p0 = HashHelper.getPrime(3);
        var p1 = HashHelper.getPrime(4);
        var p2 = HashHelper.getPrime(5);
        var p3 = HashHelper.getPrime(6);

        var hash = p0;
        if (actionPerformer != null) {
            hash  = hash * p1 +  actionPerformer.getHashCode();
        }
        if (didAttack) {
            hash  = hash * p1 +  p2;
        }
        else {
            hash  = hash * p1 +  p3;
        }
        hash = hash * p1 +  actionPerformer.getHashCode();
        hash = hash * p1 +  moveCount;
        hash = hash * p1 +  attackCount;
        return hash;
    }
}