package fruiton.fruitDb;

import haxe.ds.IntMap;
import haxe.ds.StringMap;
import haxe.Json;
import fruiton.fruitDb.models.Models.FruitonModel;
import fruiton.fruitDb.models.Models.MovementModel;
import fruiton.fruitDb.models.Models.AttackModel;
import fruiton.fruitDb.models.Models.EffectModel;
import fruiton.fruitDb.models.Models.TargetPatternModel;
import fruiton.fruitDb.models.Models.AbilityModel;

class FruitonDatabase {

    var fruitonDb:IntMap<FruitonModel>;
    var movementDb:IntMap<MovementModel>;
    var attackDb:IntMap<AttackModel>;
    var effectDb: StringMap<EffectModel>;
    var targetPatternDb:IntMap<TargetPatternModel>;
    var abilityDb:StringMap<AbilityModel>;

    public function new (dbString:String) {
        fruitonDb = new IntMap<FruitonModel>();
        movementDb = new IntMap<MovementModel>();
        attackDb = new IntMap<AttackModel>();
        effectDb = new StringMap<EffectModel>();
        targetPatternDb = new IntMap<TargetPatternModel>();
        abilityDb = new StringMap<AbilityModel>();
        loadDb(dbString);
    }

    function loadDb(dbString:String) {
        var json:Dynamic = Json.parse(dbString);

        load(json.fruitonDb, fruitonDb);
        load(json.movementDb, movementDb);
        load(json.attackDb, attackDb);
        loadStringMap(json.effectDb, effectDb);
        load(json.targetPatternDb, targetPatternDb);
        loadStringMap(json.abilitiesDb, abilityDb);
    }

    function load<T>(defs:Array<Dynamic>, map:IntMap<T>) {
        for (item in defs) {
            var id = item.id;
            var dbItem:T = item;
            map.set(id, dbItem);
        }
    }

    function loadStringMap<T>(defs:Array<Dynamic>, map:StringMap<T>) {
        for (item in defs) {
            var id = item.id;
            var dbItem:T = item;
            map.set(id, dbItem);
        }
    }

    public function getFruiton(id:Int):FruitonModel {
        return fruitonDb.get(id);
    }

    public function getEffect(name:String):EffectModel {
        return effectDb.get(name);
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

    public function getAbility(id:String){
        return abilityDb.get(id);
    }
}
