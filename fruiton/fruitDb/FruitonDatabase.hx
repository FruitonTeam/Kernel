package fruiton.fruitDb;

import haxe.ds.IntMap;
import haxe.Json;
import fruiton.fruitDb.models.Models.FruitonModel;
import fruiton.fruitDb.models.Models.MovementModel;
import fruiton.fruitDb.models.Models.AttackModel;
import fruiton.fruitDb.models.Models.TargetPatternModel;

class FruitonDatabase {

    var fruitonDb:IntMap<FruitonModel>;
    var movementDb:IntMap<MovementModel>;
    var attackDb:IntMap<AttackModel>;
    var targetPatternDb:IntMap<TargetPatternModel>;

    public function new (dbString:String) {
        fruitonDb = new IntMap<FruitonModel>();
        movementDb = new IntMap<MovementModel>();
        attackDb = new IntMap<AttackModel>();
        targetPatternDb = new IntMap<TargetPatternModel>();
        loadDb(dbString);
    }

    function loadDb(dbString:String) {
        var json:Dynamic = Json.parse(dbString);

        load(json.fruitonDb, fruitonDb);
        load(json.movementDb, movementDb);
        load(json.attackDb, attackDb);
        load(json.targetPatternDb, targetPatternDb);
    }

    function load<T>(defs:Array<Dynamic>, map:IntMap<T>) {
        for (item in defs) {
            var id = item.id;
            var dbItem:T = item;
            map.set(id, dbItem);
        }
    }

    public function getFruiton(id:Int):FruitonModel {
        return fruitonDb.get(id);
    }

    public function getTargetPattern(id:Int):TargetPatternModel {
        return targetPatternDb.get(id);
    }

    public function getMovement(id:Int):MovementModel {
        return movementDb.get(id);
    }

    public function getAttack(id:Int):AttackModel {
        return attackDb.get(id);
    }
}
