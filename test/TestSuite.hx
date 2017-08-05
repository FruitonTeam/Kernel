import massive.munit.TestSuite;

import endTurn.EndTurnTest;
import movement.BasicMoveTest;
import targetPatterns.LineTargetPatternTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(endTurn.EndTurnTest);
		add(movement.BasicMoveTest);
		add(targetPatterns.LineTargetPatternTest);
	}
}
