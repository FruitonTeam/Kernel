package test.fruitonDb;

class FruitonDbTestSuite extends massive.munit.TestSuite {

	public function new() {
		super();

		add(FruitonDbTest);
		add(FruitonFactoryTest);
	}
}
