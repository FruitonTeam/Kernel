package test.fruitonDb;

import sys.io.File;
import fruiton.fruitDb.FruitonDatabase;
import massive.munit.Assert;
import fruiton.fruitDb.models.Models;
import fruiton.fruitDb.factories.FruitonFactory;
import fruiton.kernel.Fruiton;

class FruitonFactoryTest {

    public function new() {
    }

    @BeforeClass
    public function beforeClass() {
        Sys.println("=====================");
        Sys.println("Fruiton factory tests");
        Sys.println("=====================");
    }

    var db:FruitonDatabase;

    @Before
    function beforeTest() {
        db = makeDb();
    }

    function makeDb():FruitonDatabase {
        var dbString:String = File.getContent(fruiton.Config.dbFile);
        return new FruitonDatabase(dbString);
    }

    @Test
    public function fruitonFactory_makeFruiton1_returnsFruiton() {
        Sys.println("=== running fruitonFactory_makeFruiton1_returnsFruiton");

        var fruiton:Fruiton = FruitonFactory.makeFruiton(1, db);

        Assert.isTrue(fruiton != null);
    }
}
