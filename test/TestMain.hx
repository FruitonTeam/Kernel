package;

import massive.munit.client.PrintClient;
import massive.munit.client.RichPrintClient;
import massive.munit.client.HTTPClient;
import massive.munit.client.JUnitReportClient;
import massive.munit.client.SummaryReportClient;
import massive.munit.TestRunner;

#if js
import js.Lib;
#end

/**
 * Auto generated Test Application.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestMain {

	static function main() {
		new TestMain();
	}

	public function new() {
		var suites = new Array<Class<massive.munit.TestSuite>>();
		
		suites.push(TestSuite);

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
