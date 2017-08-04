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
    public function getTargets_zeroDirectonVector_reurnsNoTargets() {
        Sys.println("=== running getTargets_zeroDirectonVector_reurnsNoTargets");

        var ltp:LineTargetPattern = new LineTargetPattern(Vector2.ZERO, -10, 10);
        var origin:Vector2 = Vector2.ZERO;
        var targets:TargetPattern.Targets = ltp.getTargets(origin);
        Assert.areEqual(0, targets.length);
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

            if (minMax == 0) {
                // Origin is not returned
                Assert.areEqual(0, targets.length);
            } else {
                Assert.areEqual(1, targets.length);
            }
        }
    }
}
