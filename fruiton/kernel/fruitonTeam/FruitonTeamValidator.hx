package fruiton.kernel.fruitonTeam;

import fruiton.fruitDb.FruitonDatabase;

class FruitonTeamValidator {

    static var REQUIRED_COUNTS:Array<Int> = [1, 3, 4];

    // fruitonIds: Array of ids of the controlled Fruiton Team.
    // fruitonDatabase: DB of all fruitons.
    // partiallyValid: Determines whether to accept uncomplete partially valid Fruiton Teams as valid.
    public static function validateFruitonTeam(fruitonIds:Array<Int>, fruitonDatabase:FruitonDatabase, partiallyValid:Bool):ValidationMessage {
        var counts = [0, 0, 0];
        var valid = true;
        var message = "";
        for (id in fruitonIds) {
            var current = fruitonDatabase.getFruiton(id);
            counts[current.type - 1]++;
        }
        for (i in 0...counts.length) {
            if (counts[i] > REQUIRED_COUNTS[i]) {
                valid = false;
                message = "Too many Fruitons of type " + (i - 1);
            } else if (!partiallyValid && counts[i] < REQUIRED_COUNTS[i]) {
                valid = false;
                message = "Not enough Fruitons of type " + (i - 1);
            }
        }
        if (valid) {
            if (partiallyValid) {
                message = "Fruiton Team is partially valid.";
            } else {
                message = "Fruiton Team is valid.";
            }
        }
        return new ValidationMessage(valid, message);
    }
}