package fruiton.kernel.targetPatterns;

class RangeTargetPattern extends TargetPattern {

    public function new (vector:Position, min:Int, max:Int) {
        super(vector, min, max);
    }

    override public function getTargets(origin:Position):TargetPattern.Targets {
        var targets:TargetPattern.Targets = new TargetPattern.Targets();

        for (x in (-max)...(max + 1)) {
            for (y in (-max)...(max + 1)) {
                targets.push(origin.add(new Position(x, y)));
            }
        }

        return targets;
    }
}