import massive.munit.TestSuite;

import attack.AttackTest;
import endTurn.EndTurnTest;
import fruitonDb.FruitonDbTest;
import fruitonDb.FruitonFactoryTest;
import fruitonTeam.FruitonTeamTest;
import gameRules.GameRulesTest;
import movement.BasicMoveTest;
import targetPatterns.LineTargetPatternTest;
import targetPatterns.RangeTargetPatternTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(attack.AttackTest);
		add(endTurn.EndTurnTest);
		add(fruitonDb.FruitonDbTest);
		add(fruitonDb.FruitonFactoryTest);
		add(fruitonTeam.FruitonTeamTest);
		add(gameRules.GameRulesTest);
		add(movement.BasicMoveTest);
		add(targetPatterns.LineTargetPatternTest);
		add(targetPatterns.RangeTargetPatternTest);
	}
}
