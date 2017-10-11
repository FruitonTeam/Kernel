package fruiton.fruitDb.factories;

import fruiton.fruitDb.models.Models.AttackModel;
import fruiton.fruitDb.models.Models.FruitonModel;
import fruiton.fruitDb.models.Models.MovementModel;
import fruiton.fruitDb.models.Models.TargetPatternModel;
import fruiton.kernel.Fruiton;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.targetPatterns.LineTargetPattern;
import fruiton.kernel.targetPatterns.RangeTargetPattern;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.MoveGenerator;
import fruiton.kernel.AttackGenerator;
import fruiton.kernel.effects.LowerAttackOnAttackEffect;
import fruiton.kernel.effects.LoweredAttackEffect;

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
            [new LowerAttackOnAttackEffect(10)],
            entry.type);
    }

    static function makeAttackGenerator(id:Int, db:FruitonDatabase):AttackGenerator {
        var entry:AttackModel = db.getAttack(id);
        return new AttackGenerator(makeTargetPattern(entry.targetPatternId, db));
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