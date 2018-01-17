package fruiton.fruitDb.factories;

import fruiton.fruitDb.models.Models.MapModel;
import fruiton.kernel.GameSettings;
import fruiton.kernel.Tile.TileType;
import fruiton.kernel.GameState;
import fruiton.kernel.exceptions.InvalidFormatException;

class MapFactory {

    public static function makeMap(id:Int, db:FruitonDatabase):TileMap {
        var entry:MapModel = db.getMap(id);

        var map:TileMap = GameSettings.createDefaultTileMap();
        for (o in entry.obstacles) {
            if (o.x < 0 || o.x > GameState.WIDTH ||
                    o.y < 0 || o.y > GameState.HEIGHT) {
                throw new InvalidFormatException("Obstacle outside of map boundaries found: [" + o.x + ", " + o.y + "]");
            }
            map[o.x][o.y] = TileType.impassable;
        }

        return map;
    }
}