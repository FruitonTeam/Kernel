package fruiton.kernel;

import fruiton.kernel.exceptions.InvalidArgumentException;
import fruiton.kernel.gameModes.GameMode;
import fruiton.kernel.gameModes.StandardGameMode;

typedef TileMap = Array<Array<Tile.TileType>>;

class GameSettings {

    public var map(default, default):TileMap;
    public var gameMode(default, default):GameMode;

    public function new(map:TileMap, gameMode:GameMode) {
        checkDimensions(map);
        this.map = [for (c in map) c.copy()];
        this.gameMode = gameMode;
    }

    public static function createDefaultTileMap():TileMap {
        return [for (x in 0...GameState.WIDTH) [for (y in 0...GameState.HEIGHT) Tile.TileType.passable]];
    }

    public static function createDefault():GameSettings {
        var mapDefault:TileMap = createDefaultTileMap();
        return new GameSettings(mapDefault, new StandardGameMode());
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