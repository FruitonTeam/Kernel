package fruiton.kernel.targetPatterns;

/**
 * Target pattern following a simple line given by vector multiplied by numbers from min to max (inclusive).
 */
class LineTargetPattern extends TargetPattern {

    public function new (vector:Position, min:Int, max:Int) {
        super(vector, min, max);
    }

    override public function getTargets(origin:Position):TargetPattern.Targets {
        var targets:TargetPattern.Targets = new TargetPattern.Targets();

        for (i in min...(max + 1)) {
            var newPos:Position = origin.add(vector.mul(i));
            if (!newPos.equals(origin)) {
                targets.push(newPos);
            }
        }

        return targets;
    }
}
