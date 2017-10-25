package test.fruitonTeam;

import sys.io.File;
import fruiton.kernel.fruitonTeam.FruitonTeamValidator;
import fruiton.kernel.fruitonTeam.ValidationResult;
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
        Sys.println("=== running fruitonTeamValidator_getsPartiallyValidTeam_returnsApproval");

        var team = [1, 2, 2, 2, 2, 3, 3, 3, 3, 3];
        var dbString:String = File.getContent(fruiton.Config.dbFile);
        var fruitonDB = new FruitonDatabase(dbString);
        var result = FruitonTeamValidator.validateFruitonTeam(team, fruitonDB);
        Assert.isTrue(result.valid && result.complete);
    }
}