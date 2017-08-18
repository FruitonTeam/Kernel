package fruiton.fruitDb.factories;

import fruiton.fruitDb.models.Models;
import fruiton.kernel.Fruiton;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.targetPatterns.LineTargetPattern;
import fruiton.kernel.targetPatterns.RangeTargetPattern;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.MoveGenerator;
import fruiton.kernel.AttackGenerator;

enum TargetPatternType {
    Line;
    Range;
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
            moveGenerators,
            []);
    }

    public static function makeAttackGenerator(id:Int, db:FruitonDatabase):AttackGenerator {
        return null;
    }

    public static function makeMoveGenerator(id:Int, db:FruitonDatabase):MoveGenerator {
        var entry:MovementModel = db.getMovement(id);
        return new MoveGenerator(makeTargetPattern(entry.targetPatternId, db));
    }

    public static function makeTargetPattern(id:Int, db:FruitonDatabase):TargetPattern {
        var entry:TargetPatternModel = db.getTargetPattern(id);
        var type:TargetPatternType = Type.createEnum(TargetPatternType, entry.type);
        switch (type) {
            case TargetPatternType.Line: {
                return new LineTargetPattern(new Vector2(entry.x, entry.y), entry.min, entry.max);
            }
            case TargetPatternType.Range: {
                return new RangeTargetPattern(new Vector2(entry.x, entry.y), entry.min, entry.max);
            }
        }
    }
}