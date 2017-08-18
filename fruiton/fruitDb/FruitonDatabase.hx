package fruiton.fruitDb;

import sys.io.File;
import haxe.ds.IntMap;
import haxe.Json;
import fruiton.fruitDb.models.Models;

class FruitonDatabase {

    var fruitonDb:IntMap<FruitonModel>;
    //var movementDb:IntMap<MovementModel>;

    public function new (dbFile:String) {
        fruitonDb = new IntMap<FruitonModel>();
        loadDb(dbFile);
    }

    function loadDb(dbFile:String) {
        var dbString:String = File.getContent(dbFile);
        var json:Dynamic = Json.parse(dbString);
        loadFruitons(json);
    }

    function loadFruitons(dbJson:Dynamic) {
        var fruitonDefs:Array<Dynamic> = dbJson.fruitonDb;
        for (fruitonJson in fruitonDefs) {
            var fruiton:FruitonModel = fruitonJson;
            fruitonDb.set(fruiton.id, fruiton);
        }
    }

    public function get(id:Int):FruitonModel {
        return fruitonDb.get(id);
    }
}
