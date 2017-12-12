import massive.munit.TestSuite;

import abilities.AttackRulesTest;
import abilities.AttackTest;
import abilities.HealTest;
import effects.EffectsTest;
import endTurn.EndTurnTest;
import fruitonDb.FruitonDbTest;
import fruitonDb.FruitonFactoryTest;
import fruitonTeam.FruitonTeamTest;
import gameRules.GameRulesTest;
import hashFunctions.HashFunctionsTest;
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

		add(abilities.AttackRulesTest);
		add(abilities.AttackTest);
		add(abilities.HealTest);
		add(effects.EffectsTest);
		add(endTurn.EndTurnTest);
		add(fruitonDb.FruitonDbTest);
		add(fruitonDb.FruitonFactoryTest);
		add(fruitonTeam.FruitonTeamTest);
		add(gameRules.GameRulesTest);
		add(hashFunctions.HashFunctionsTest);
		add(movement.BasicMoveTest);
		add(targetPatterns.LineTargetPatternTest);
		add(targetPatterns.RangeTargetPatternTest);
	}
}
