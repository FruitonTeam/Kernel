package fruiton.kernel.targetPatterns;

typedef Targets = Array<Position>;

/**
 *  Immutable class representing target pattern
 */
class TargetPattern {

    var vector:Position;
    var min:Int;
    var max:Int;

    function new (vector:Position, min:Int, max:Int) {
        this.vector = vector;
        this.min = min;
        this.max = max;
    }

    /**
     *  Generates all targets from orgin by this target pattern
     *  @param origin - relative to origin are targets generated
     *  @return Targets generated by this target pattern from given origin
     */
    public function getTargets(origin:Position):Targets {
        return new Targets();
    }
}
