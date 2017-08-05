package test.targetPatterns;


class TargetPatternsTestSuite extends massive.munit.TestSuite {

	public function new() {
		super();

		add(LineTargetPatternTest);
		add(RangeTargetPatternTest);
	}
}
