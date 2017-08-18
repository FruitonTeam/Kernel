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
		Sys.println("==========================");
        Sys.println("Range target pattern tests");
        Sys.println("==========================");
	}

    function makeZeroPattern():RangeTargetPattern {
        return new RangeTargetPattern(Vector2.ZERO, 0, 0);
    }

    function makeRangePattern(range:Int):RangeTargetPattern {
        return new RangeTargetPattern(Vector2.ZERO, 0, range);
    }

    function makeRangePatternWithGap(min:Int, max:Int) {
        return new RangeTargetPattern(Vector2.ZERO, min, max);
    }

    @Test
    public function getTargets_nullOrigin_throwsNullReferenceException() {
        Sys.println("=== running getTargets_nullOrigin_throwsNullReferenceException");

        var ltp:RangeTargetPattern = makeZeroPattern();
        try {
            ltp.getTargets(null);

            // Unreachable
            Assert.isTrue(false);
        } catch (e:InvalidArgumentException) {
            // Expected behavior
        }
    }

    @Test
    public function getTargets_zeroDistace_returnsOnlyOrigin() {
        Sys.println("=== running getTargets_zeroDistace_returnsOnlyOrigin");

        var ltp:RangeTargetPattern = makeZeroPattern();
        var origin:Vector2 = Vector2.ZERO;
        var targets:TargetPattern.Targets = ltp.getTargets(origin);

        for (t in targets) {
            Assert.isTrue(origin == t);
        }
    }

    @Test
    public function getTargets_zeroDistance_doesNotReturnDuplicates() {
        Sys.println("=== running getTargets_zeroDistance_doesNotReturnDuplicates");

        var ltp:RangeTargetPattern = makeZeroPattern();
        var origin:Vector2 = Vector2.ZERO;
        var targets:TargetPattern.Targets = ltp.getTargets(origin);

        Assert.areEqual(1, targets.length);
    }

    @Test
    public function getTargets_negativeRange_returnsNoTargets() {
        Sys.println("=== running getTargets_minGreaterThanMax_returnsNoTargets");

        for (range in -100...0) {
            var ltp:RangeTargetPattern = makeRangePattern(range);
            var origin:Vector2 = Vector2.ZERO;
            var targets:TargetPattern.Targets = ltp.getTargets(origin);
            Assert.areEqual(0, targets.length);
        }
    }

    @Test
    public function getTargets_positiveRange_returns2RangePlus1SquaredTargets() {
        Sys.println("=== running getTargets_positiveRange_returns2RangePlus1SquaredTargets");

        for (range in 0...50) {
            var ltp:RangeTargetPattern = makeRangePattern(range);
            var origin:Vector2 = Vector2.ZERO;
            var targets:TargetPattern.Targets = ltp.getTargets(origin);

            Assert.areEqual(Math.pow((2 * range) + 1, 2), targets.length);
        }
    }

    @Test
    public function getTargets_positiveRange_returnsTargetsInBox() {
        Sys.println("=== running getTargets_positiveRange_returnsTargetsInBox");

        var range:Int = 10;
        var ltp:RangeTargetPattern = makeRangePattern(range);
        var origin:Vector2 = Vector2.ZERO;
        var targets:TargetPattern.Targets = ltp.getTargets(origin);

        for (t in targets) {
            Assert.isTrue(t.x >= -range);
            Assert.isTrue(t.x <= range);
            Assert.isTrue(t.y >= -range);
            Assert.isTrue(t.y <= range);
        }
    }

    @Test
    public function getTargets_patternWithGap_doesNotReturnTargetsInGap() {
        Sys.println("=== running getTargets_patternWithGap_doesNotReturnTargetsInGap");

        var origin:Vector2 = Vector2.ZERO;

        for (min in 0...10) {
            for (max in min...10) {
                var rtp:RangeTargetPattern = makeRangePatternWithGap(min, max);
                var targets:TargetPattern.Targets = rtp.getTargets(origin);

                for (t in targets) {
                    if (Math.abs(t.x) < min &&
                        Math.abs(t.y) < min) {
                        // Target is in gap
                        Assert.isTrue(false);
                    }
                }
            }
        }
    }

    @Test
    public function getTargets_minHigherThanMax_returnsNoTargets() {
        Sys.println("=== running getTargets_minHigherThanMax_returnsNoTargets");

        var origin:Vector2 = Vector2.ZERO;

        for (max in -5...5) {
            for (min in (max + 1)...5) {
                var rtp:RangeTargetPattern = makeRangePatternWithGap(min, max);
                var targets:TargetPattern.Targets = rtp.getTargets(origin);
                Assert.isTrue(targets.length == 0);
            }
        }
    }
}
