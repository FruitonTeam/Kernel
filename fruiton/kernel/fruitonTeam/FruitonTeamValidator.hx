package fruiton.kernel.fruitonTeam;

import fruiton.fruitDb.FruitonDatabase;

class FruitonTeamValidator {

    static var REQUIRED_COUNTS(default, never):Array<Int> = [1, 3, 4];

    /**
     * @param fruitonIds Array of ids of the controlled Fruiton Team.
     * @param fruitonDatabase DB of all fruitons.
     * @param partiallyValid Determines whether to accept uncomplete partially valid Fruiton Teams as valid.
     * @return Validation result.
     */
    public static function validateFruitonTeam(fruitonIds:Array<Int>, fruitonDatabase:FruitonDatabase):ValidationResult {
        var counts = [0, 0, 0];
        var valid = true;
        var complete = true;
        for (id in fruitonIds) {
            var current = fruitonDatabase.getFruiton(id);
            counts[current.type - 1]++;
        }
        for (i in 0...counts.length) {
            if (counts[i] > REQUIRED_COUNTS[i]) {
                valid = false;
            } else if (counts[i] < REQUIRED_COUNTS[i]) {
                complete = false;
            }
        }
        return new ValidationResult(valid, complete);
    }
}