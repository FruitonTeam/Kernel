package fruiton.kernel.targetPatterns;

import fruiton.dataStructures.Vector2;
import fruiton.dataStructures.collections.ArrayOfEquitables;

/**
 * Target pattern following a simple line given by vector multiplied by numbers from min to max (inclusive).
 */
class LineTargetPattern extends TargetPattern {

    public function new (vector:Vector2, min:Int, max:Int) {
        super(vector, min, max);
    }

    override public function getTargets(origin:Vector2):TargetPattern.Targets {
        var targets:ArrayOfEquitables<Vector2> = super.getTargets(origin);

        for (i in min...(max + 1)) {
            var newPos:Vector2 = origin + (i * vector);
            targets.push(newPos);
        }

        // Until we have a hash set we may use this n log(n) solution
        targets.sort(Vector2.xyOrdering);
        targets.unique();

        return targets;
    }
}
