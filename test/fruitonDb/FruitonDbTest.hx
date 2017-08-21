package test.fruitonDb;

import fruiton.fruitDb.FruitonDatabase;
import massive.munit.Assert;
import fruiton.fruitDb.models.Models;

class FruitonDbTest {

    public function new() {
    }

    @BeforeClass
    public function beforeClass() {
        Sys.println("======================");
        Sys.println("Fruiton database tests");
        Sys.println("======================");
    }

    var db:FruitonDatabase;

    @Before
    function beforeTest() {
        db = makeDb();
    }

    function makeDb():FruitonDatabase {
        return new FruitonDatabase(fruiton.Config.dbFile);
    }

    @Test
    public function fruitonDatabaseCtor_byDefault_createsDatabase() {
        Sys.println("=== running fruitonDatabaseCtor_byDefault_createsDatabase");

        Assert.isTrue(db != null);
    }

    @Test
    public function fruitonDatabase_getFruiton1_returnsFruiton() {
        Sys.println("=== running fruitonDatabase_getFruiton1_returnsFruiton");

        var fruiton:FruitonModel = db.getFruiton(1);

        Assert.isTrue(fruiton != null);
    }
}
