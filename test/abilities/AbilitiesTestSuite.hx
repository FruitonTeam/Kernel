package test.abilities;

class AbilitiesTestSuite extends massive.munit.TestSuite {

	public function new() {
		super();

		add(AttackTest);
		add(AttackRulesTest);
		add(HealTest);
	}
}
