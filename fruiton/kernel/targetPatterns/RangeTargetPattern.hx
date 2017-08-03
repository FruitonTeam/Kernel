package fruiton.kernel.targetPatterns;

import fruiton.dataStructures.Vector2;

class RangeTargetPattern extends TargetPattern {

    public function new (vector:Vector2, min:Int, max:Int) {
        super(vector, min, max);
    }

    override public function getTargets(origin:Vector2):TargetPattern.Targets {
        var targets:TargetPattern.Targets = new TargetPattern.Targets();

        for (x in (-max)...(max + 1)) {
            for (y in (-max)...(max + 1)) {
                targets.push(origin.add(new Vector2(x, y)));
            }
        }

        return targets;
    }
}