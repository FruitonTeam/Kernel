package test.targetPatterns;

import fruiton.kernel.targetPatterns.*;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.exceptions.*;
import massive.munit.Assert;

class RangeTargetPatternTest {

    public function new() {
    }

    @BeforeClass
	public function beforeClass() {
		Sys.println("=========================");
        Sys.println("Range target pattern tests");
        Sys.println("=========================");
	}

    function zeroPatternFactory():RangeTargetPattern {
        return new RangeTargetPattern(Vector2.ZERO, 0, 0);
    }

    function rangePatternFactory(range:Int):RangeTargetPattern {
        return new RangeTargetPattern(Vector2.ZERO, 0, range);
    }

    @Test
    public function getTargets_nullOrigin_throwsNullReferenceException() {
        Sys.println("=== running getTargets_nullOrigin_throwsNullReferenceException");

        var ltp:RangeTargetPattern = zeroPatternFactory();
        try {
            ltp.getTargets(null);

            // Unreachable
            Assert.isTrue(false);
        } catch (e:NullReferenceException) {
            // Expected behavior
        }
    }

    @Test
    public function getTargets_zeroDistace_returnsOnlyOrigin() {
        Sys.println("=== running getTargets_zeroDistace_returnsOnlyOrigin");

        var ltp:RangeTargetPattern = zeroPatternFactory();
        var origin:Vector2 = Vector2.ZERO;
        var targets:TargetPattern.Targets = ltp.getTargets(origin);

        for (t in targets) {
            Assert.isTrue(origin == t);
        }
    }

    @Test
    public function getTargets_negativeRange_returnsNoTargets() {
        Sys.println("=== running getTargets_minGreaterThanMax_returnsNoTargets");

        for (range in -100...0) {
            var ltp:RangeTargetPattern = rangePatternFactory(range);
            var origin:Vector2 = Vector2.ZERO;
            var targets:TargetPattern.Targets = ltp.getTargets(origin);
            Assert.areEqual(0, targets.length);
        }
    }

    @Test
    public function getTargets_positiveRange_returns2RangePlus1SquaredTargets() {
        Sys.println("=== running getTargets_positiveRange_returns2RangePlus1SquaredTargets");

        for (range in 0...50) {
            var ltp:RangeTargetPattern = rangePatternFactory(range);
            var origin:Vector2 = Vector2.ZERO;
            var targets:TargetPattern.Targets = ltp.getTargets(origin);

            Assert.areEqual(Math.pow((2 * range) + 1, 2), targets.length);
        }
    }

    @Test
    public function getTargets_positiveRange_returnsTargetsInBox() {
        Sys.println("=== running getTargets_positiveRange_returnsTargetsInBox");

        var range:Int = 10;
        var ltp:RangeTargetPattern = rangePatternFactory(range);
        var origin:Vector2 = Vector2.ZERO;
        var targets:TargetPattern.Targets = ltp.getTargets(origin);

        for (t in targets) {
            Assert.isTrue(t.x >= -range);
            Assert.isTrue(t.x <= range);
            Assert.isTrue(t.y >= -range);
            Assert.isTrue(t.y <= range);
        }
    }
}
