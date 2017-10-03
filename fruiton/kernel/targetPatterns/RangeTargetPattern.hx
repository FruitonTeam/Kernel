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
        return HashHelper.getPrime(7) * vector.getHashCode() +
         HashHelper.getPrime(10) * min + 
         HashHelper.getPrime(11) * max + 
         HashHelper.getPrime(18); 
    }
}