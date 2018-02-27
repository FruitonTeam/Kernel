package fruiton.kernel.fruitonTeam;

import fruiton.dataStructures.collections.ArrayOfEquitables;
import fruiton.dataStructures.Point;
import fruiton.fruitDb.FruitonDatabase;
import fruiton.kernel.exceptions.InvalidArgumentException;

class FruitonTeamValidator {

    static var REQUIRED_COUNTS(default, never):Array<Int> = [1, 4, 5];

    static var VALID_KING_POSITIONS(default, never):ArrayOfEquitables<Point> = [
        new Point(4, 0), new Point(4, GameState.WIDTH)
    ];

    static var VALID_MAJOR_POSITIONS(default, never):ArrayOfEquitables<Point> = [
        new Point(2, 0), new Point(2, GameState.WIDTH),
        new Point(3, 0), new Point(3, GameState.WIDTH),
        new Point(5, 0), new Point(5, GameState.WIDTH),
        new Point(6, 0), new Point(6, GameState.WIDTH)
    ];

    static var VALID_MINOR_POSITIONS(default, never):ArrayOfEquitables<Point> = [
        new Point(2, 1), new Point(2, GameState.WIDTH - 1),
        new Point(3, 1), new Point(3, GameState.WIDTH - 1),
        new Point(4, 1), new Point(4, GameState.WIDTH - 1),
        new Point(5, 1), new Point(5, GameState.WIDTH - 1),
        new Point(6, 1), new Point(6, GameState.WIDTH - 1)
    ];

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

    public static function haveValidPositions(fruitons:Array<Fruiton>):Bool {

        var usedPositions:ArrayOfEquitables<Point> = [];

        for (fruiton in fruitons) {
            if (!hasValidPosition(fruiton)) {
                return false;
            }
            if (usedPositions.contains(fruiton.position)) {
                return false;
            }
            usedPositions.push(fruiton.position);
        }

        return true;
    }

    static function hasValidPosition(fruiton:Fruiton):Bool {
        switch (fruiton.type) {
            case Fruiton.KING_TYPE: {
                return VALID_KING_POSITIONS.contains(fruiton.position);
            }
            case Fruiton.MAJOR_TYPE: {
                return VALID_MAJOR_POSITIONS.contains(fruiton.position);
            }
            case Fruiton.MINOR_TYPE: {
                return VALID_MINOR_POSITIONS.contains(fruiton.position);
            }
            default: {
                throw new InvalidArgumentException("Unknown fruiton type " + fruiton.type);
            }
        }
    }
}