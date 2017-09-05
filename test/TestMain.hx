package test;

import massive.munit.client.HTTPClient;
import massive.munit.client.JUnitReportClient;
import massive.munit.TestRunner;

/**
 * Auto generated Test Application.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestMain {

	static function main() {
		new TestMain();
	}

	public function new() {
		var suites:Array<Class<massive.munit.TestSuite>> = [];

		suites.push(test.movement.MoveTestSuite);
		suites.push(test.endTurn.EndTurnTestSuite);
		suites.push(test.targetPatterns.TargetPatternsTestSuite);
		suites.push(test.attack.AttackTestSuite);
		suites.push(test.fruitonDb.FruitonDbTestSuite);
		suites.push(test.fruitonTeam.FruitonTeamTestSuite);

		var client = new HTTPClient(new JUnitReportClient());

		var runner:TestRunner = new TestRunner(client);

		runner.completionHandler = completionHandler;

		runner.run(suites);
	}

	/*
		updates the background color and closes the current browser
		for flash and html targets (useful for continous integration servers)
	*/
	function completionHandler(successful:Bool) {
		Sys.exit(0);
	}
}
