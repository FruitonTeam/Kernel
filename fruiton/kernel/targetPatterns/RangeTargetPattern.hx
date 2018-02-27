package fruiton.kernel.targetPatterns;

import fruiton.dataStructures.Vector2;

/**
 * Produces targets in range (ring) around given `origin` from `min` to `max` (both inclusive)
 */
class RangeTargetPattern extends TargetPattern {

    public function new (vector:Vector2, min:Int, max:Int) {
        super(vector, min, max);
    }

    override public function getTargets(origin:Vector2):TargetPattern.Targets {
        var targets:TargetPattern.Targets = super.getTargets(origin);

        for (x in (-max)...(max + 1)) {
            for (y in (-max)...(max + 1)) {
                if (Math.abs(x) < min &&
                    Math.abs(y) < min) {
                    continue;
                }
                targets.push(origin + new Vector2(x, y));
            }
        }

        return targets;
    }

    override public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 +  vector.getHashCode();
        hash = hash * p1 +  min;
        hash = hash * p1 +  max;
        return hash;
    }

    override public function toString():String {
        if (min == max) {
            return Std.string(min);
        }
        return min + "-" + max;
    }
}