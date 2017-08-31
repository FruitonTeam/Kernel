package test.fruitonTeam;

import fruiton.kernel.fruitonTeam.FruitonTeamValidator;
import fruiton.kernel.fruitonTeam.ValidationMessage;
import fruiton.fruitDb.FruitonDatabase;
import massive.munit.Assert;

class FruitonTeamTest {

    public function new() {}

    @BeforeClass
    public function beforeClass() {
        Sys.println("======================");
        Sys.println("Fruiton Team tests");
        Sys.println("======================");
    }

    @Test
    public function fruitonTeamValidator_getsPartiallyValidTeam_returnsApproval() {
        var team = [1, 2, 2, 2, 3, 3, 3 ,3];
        var fruitonDB = new FruitonDatabase(fruiton.Config.dbFile);
        var result = FruitonTeamValidator.validateFruitonTeam(team, fruitonDB, true);
        Assert.isTrue(result.success);
    }
}