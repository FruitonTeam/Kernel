package test.targetPatterns;

import fruiton.kernel.targetPatterns.*;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.exceptions.*;
import massive.munit.Assert;

class LineTargetPatternTest {

    public function new() {
    }

    @BeforeClass
	public function beforeClass() {
		Sys.println("=========================");
        Sys.println("Line target pattern tests");
        Sys.println("=========================");
	}

    @Test
    public function getTargets_nullOrigin_throwsNullReferenceException() {
        Sys.println("=== running getTargets_nullOrigin_throwsNullReferenceException");

        var ltp:LineTargetPattern = new LineTargetPattern(new Vector2(0, 0), 0, 0);
        try {
            ltp.getTargets(null);

            // Unreachable
            Assert.isTrue(false);
        } catch (e:NullReferenceException) {
            // Expected behavior
        }
    }

    @Test
    public function getTargets_zeroDirectonVector_returnsOnlyOrigin() {
        Sys.println("=== running getTargets_zeroDirectonVector_returnsOnlyOrigin");

        var min:Int = -10;
        var max:Int = 10;
        var ltp:LineTargetPattern = new LineTargetPattern(Vector2.ZERO, min, max);
        var origin:Vector2 = Vector2.ZERO;
        var targets:TargetPattern.Targets = ltp.getTargets(origin);

        for (t in targets) {
            Assert.isTrue(origin == t);
        }
    }

    @Test
    public function getTargets_minGreaterThanMax_returnsNoTargets() {
        Sys.println("=== running getTargets_minGreaterThanMax_returnsNoTargets");

        for (min in -100...100) {
            var ltp:LineTargetPattern = new LineTargetPattern(new Vector2(0, 1), min, min - 1);
            var origin:Vector2 = Vector2.ZERO;
            var targets:TargetPattern.Targets = ltp.getTargets(origin);
            Assert.areEqual(0, targets.length);
        }
    }

    @Test
    public function getTargets_minEqualsToMax_returnsOneTarget() {
        Sys.println("=== running getTargets_minEqualsToMax_returnsOneTarget");

        for (minMax in -100...100) {
            var ltp:LineTargetPattern = new LineTargetPattern(new Vector2(0, 1), minMax, minMax);
            var origin:Vector2 = Vector2.ZERO;
            var targets:TargetPattern.Targets = ltp.getTargets(origin);

            Assert.areEqual(1, targets.length);
        }
    }

    @Test
    public function getTargets_fromMinus10to10_returnsLineOf21() {
        Sys.println("=== running getTargets_fromMinus10to10_returnsLineOf21");

        // Generate all 8 directions
        var directions:Array<Vector2> = [];
        for (x in -1...1) {
            for (y in -1...1) {
                if (x != 0 && y != 0) {
                    directions.push(new Vector2(x, y));
                }
            }
        }

        for (d in directions) {
            var min:Int = -10;
            var max:Int = 10;
            var ltp:LineTargetPattern = new LineTargetPattern(Vector2.ZERO, min, max);
            var origin:Vector2 = Vector2.ZERO;
            var targets:TargetPattern.Targets = ltp.getTargets(origin);
            Assert.areEqual(21, targets.length);
        }
    }
}
