import massive.munit.TestSuite;

import BasicMoveTest;

class MoveTestSuite extends massive.munit.TestSuite {

	public function new() {
		super();

		add(BasicMoveTest);
	}
}
