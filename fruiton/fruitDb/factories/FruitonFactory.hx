package fruiton.fruitDb.factories;

import fruiton.fruitDb.models.Models.AttackModel;
import fruiton.fruitDb.models.Models.FruitonModel;
import fruiton.fruitDb.models.Models.EffectModel;
import fruiton.fruitDb.models.Models.MovementModel;
import fruiton.fruitDb.models.Models.TargetPatternModel;
import fruiton.kernel.Fruiton;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.targetPatterns.LineTargetPattern;
import fruiton.kernel.targetPatterns.RangeTargetPattern;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.MoveGenerator;
import fruiton.kernel.AttackGenerator;
import fruiton.kernel.effects.Effect;
import fruiton.kernel.effects.LowerAttackOnAttackEffect;

enum EffectType {
    lowerAttackOnAttack;
}

enum TargetPatternType {
    line;
    range;
}

class FruitonFactory {

    public static function makeFruiton(id:Int, db:FruitonDatabase):Fruiton {
        var entry:FruitonModel = db.getFruiton(id);

        var moveGenerators:MoveGenerators = new MoveGenerators();
        for (moveId in entry.movements) {
            moveGenerators.push(makeMoveGenerator(moveId, db));
        }

        var effects:Effects = new Effects();
        for (effectId in entry.effects) {
            effects.push(makeEffect(effectId, db));
        }

        var attackGenerators:AttackGenerators = new AttackGenerators();
        for (attackId in entry.attacks) {
            attackGenerators.push(makeAttackGenerator(attackId, db));
        }

        return new Fruiton(
            id,
            Vector2.ZERO,
            null,
            entry.hp,
            entry.damage,
            entry.model,
            moveGenerators,
            attackGenerators,
            effects,
            entry.type);
    }

    static function makeAttackGenerator(id:Int, db:FruitonDatabase):AttackGenerator {
        var entry:AttackModel = db.getAttack(id);
        return new AttackGenerator(makeTargetPattern(entry.targetPatternId, db));
    }

    static function makeEffect(id:String, db:FruitonDatabase): Effect{
        var entry:EffectModel = db.getEffect(id);
        var type:EffectType = Type.createEnum(EffectType, entry.className);
        switch (type) {
            case EffectType.lowerAttackOnAttack: {
                return new LowerAttackOnAttackEffect(entry.params[0]);
            }
        }
    }

    static function makeMoveGenerator(id:Int, db:FruitonDatabase):MoveGenerator {
        var entry:MovementModel = db.getMovement(id);
        return new MoveGenerator(makeTargetPattern(entry.targetPatternId, db));
    }

    static function makeTargetPattern(id:Int, db:FruitonDatabase):TargetPattern {
        var entry:TargetPatternModel = db.getTargetPattern(id);
        var type:TargetPatternType = Type.createEnum(TargetPatternType, entry.type);
        switch (type) {
            case TargetPatternType.line: {
                return new LineTargetPattern(new Vector2(entry.x, entry.y), entry.min, entry.max);
            }
            case TargetPatternType.range: {
                return new RangeTargetPattern(new Vector2(entry.x, entry.y), entry.min, entry.max);
            }
        }
    }
}