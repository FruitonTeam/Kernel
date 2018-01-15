package fruiton.kernel;

import fruiton.kernel.exceptions.InvalidArgumentException;

typedef TileMap = Array<Array<Tile.TileType>>;

class GameSettings {

    public var map(default, null):TileMap;

    public function new(map:TileMap) {
        checkDimensions(map);
        this.map = [for (c in map) c.copy()];
    }

    public static function createDefault():GameSettings {
        var mapDefault:TileMap = [for (x in 0...GameState.WIDTH) [for (y in 0...GameState.HEIGHT) Tile.TileType.passable]];
        return new GameSettings(mapDefault);
    }

    @SuppressWarnings("checkstyle:MultipleStringLiterals") // ", " is used multiple times
    static function checkDimensions(mapToCheck:TileMap) {
        var isFine:Bool = true;
        if (mapToCheck.length != GameState.WIDTH) {
            isFine = false;
        } else {
            for (column in mapToCheck) {
                if (column.length != GameState.HEIGHT) {
                    isFine = false;
                    break;
                }
            }
        }

        if (!isFine) {
            var msg:String;
            if (mapToCheck.length > 0) {
                msg = "Map has wrong dimensions: [" + mapToCheck.length + ", " + mapToCheck[0].length +
                "]. Expected: [" + GameState.WIDTH + ", " + GameState.HEIGHT + "].";
            } else {
                msg = "Map has wrong dimensions: [0, 0]. Expected: [" + GameState.WIDTH + ", " + GameState.HEIGHT + "].";
            }
            throw new InvalidArgumentException(msg);
        }
    }
}