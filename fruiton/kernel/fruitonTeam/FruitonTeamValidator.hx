package fruiton.kernel.fruitonTeam;

import fruiton.dataStructures.collections.ArrayOfEquitables;
import fruiton.dataStructures.Point;
import fruiton.fruitDb.FruitonDatabase;
import fruiton.kernel.exceptions.InvalidArgumentException;

class FruitonTeamValidator {

    static var REQUIRED_COUNTS(default, never):Array<Int> = [1, 4, 5];

    static var WIDTH_MIDDLE(default, never):Int = Math.floor(GameState.WIDTH / 2);

    static var VALID_KING_POSITIONS(default, never):ArrayOfEquitables<Point> = [
        new Point(WIDTH_MIDDLE, 0), new Point(WIDTH_MIDDLE, GameState.HEIGHT - 1)
    ];

    static var VALID_MAJOR_POSITIONS(default, never):ArrayOfEquitables<Point> = [
        new Point(WIDTH_MIDDLE - 2, 0), new Point(WIDTH_MIDDLE - 2, GameState.HEIGHT - 1),
        new Point(WIDTH_MIDDLE - 1, 0), new Point(WIDTH_MIDDLE - 1, GameState.HEIGHT - 1),
        new Point(WIDTH_MIDDLE + 1, 0), new Point(WIDTH_MIDDLE + 1, GameState.HEIGHT - 1),
        new Point(WIDTH_MIDDLE + 2, 0), new Point(WIDTH_MIDDLE + 2, GameState.HEIGHT - 1)
    ];

    static var VALID_MINOR_POSITIONS(default, never):ArrayOfEquitables<Point> = [
        new Point(WIDTH_MIDDLE - 2, 1), new Point(WIDTH_MIDDLE - 2, GameState.HEIGHT - 2),
        new Point(WIDTH_MIDDLE - 1, 1), new Point(WIDTH_MIDDLE - 1, GameState.HEIGHT - 2),
        new Point(WIDTH_MIDDLE, 1), new Point(WIDTH_MIDDLE, GameState.HEIGHT - 2),
        new Point(WIDTH_MIDDLE + 1, 1), new Point(WIDTH_MIDDLE + 1, GameState.HEIGHT - 2),
        new Point(WIDTH_MIDDLE + 2, 1), new Point(WIDTH_MIDDLE + 2, GameState.HEIGHT - 2)
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

    /**
     * Determines whether given fruitons have valid positions in one team.
     * @param fruitons fruitons to validate
     * @return true if fruitons have valid position for their type and if no fruitons have the same position,
     * false otherwise
     */
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