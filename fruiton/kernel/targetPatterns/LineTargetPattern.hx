package fruiton.kernel.targetPatterns;

import fruiton.dataStructures.Vector2;

/**
 * Target pattern following a simple line given by vector multiplied by numbers from min to max (inclusive).
 */
class LineTargetPattern extends TargetPattern {

    public function new (vector:Vector2, min:Int, max:Int) {
        super(vector, min, max);
    }

    override public function getTargets(origin:Vector2):TargetPattern.Targets {
        var targets:TargetPattern.Targets = new TargetPattern.Targets();

        for (i in min...(max + 1)) {
            var newPos:Vector2 = origin + (i * vector);
            if (newPos != origin) {
                targets.push(newPos);
            }
        }

        return targets;
    }
}
