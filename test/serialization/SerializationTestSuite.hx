package test.serialization;

class SerializationTestSuite extends massive.munit.TestSuite {

	public function new() {
		super();

		add(SerializationTest);
	}
}
