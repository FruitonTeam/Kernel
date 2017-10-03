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
        return (actionPerformer == null ? 0 : HashHelper.getPrime(14) * actionPerformer.getHashCode()) +
         HashHelper.getPrime(16) * moveCount + 
         HashHelper.getPrime(18) * attackCount + 
         (didAttack ? HashHelper.getPrime(19) : HashHelper.getPrime(20)) + 
         HashHelper.getPrime(21);
    }
}