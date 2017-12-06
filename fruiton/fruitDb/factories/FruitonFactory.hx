package fruiton.fruitDb.factories;

import fruiton.fruitDb.models.Models.AttackModel;
import fruiton.fruitDb.models.Models.FruitonModel;
import fruiton.fruitDb.models.Models.EffectModel;
import fruiton.fruitDb.models.Models.MovementModel;
import fruiton.fruitDb.models.Models.TargetPatternModel;
import fruiton.fruitDb.models.Models.AbilityModel;
import fruiton.kernel.Fruiton;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.targetPatterns.LineTargetPattern;
import fruiton.kernel.targetPatterns.RangeTargetPattern;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.MoveGenerator;
import fruiton.kernel.AttackGenerator;
import fruiton.kernel.effects.Effect;
import fruiton.kernel.exceptions.Exception;
import fruiton.dataStructures.FruitonAttributes;
import fruiton.kernel.effects.LoweredAttackEffect;
import fruiton.kernel.effects.triggers.OnAttackTrigger;
import fruiton.kernel.effects.triggers.OnDeathTrigger;
import fruiton.kernel.abilities.Ability;
import fruiton.kernel.abilities.HealAbility;

enum TriggerType {
    onAttack;
    onDeath;
}

enum EffectType {
    lowerAttack;
}

enum TargetPatternType {
    line;
    range;
}

enum AbilityType {
    heal;
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

        var fruitonAttributes:FruitonAttributes = new FruitonAttributes(entry.hp, entry.damage, entry.heal);

        var abilities:Abilities = new Abilities();
        for (abilityId in entry.abilities) {
            abilities.push(makeAbility(abilityId, db));
        }

        return new Fruiton(
            id,
            Vector2.ZERO,
            null,
            entry.model,
            moveGenerators,
            attackGenerators,
            abilities,
            effects,
            entry.type,
            fruitonAttributes);
    }

    static function makeAttackGenerator(id:Int, db:FruitonDatabase):AttackGenerator {
        var entry:AttackModel = db.getAttack(id);
        return new AttackGenerator(makeTargetPattern(entry.targetPatternId, db));
    }

    static function makeAbility(id:String, db:FruitonDatabase):Ability {
        var entry:AbilityModel = db.getAbility(id);
        var abilityType:AbilityType = Type.createEnum(AbilityType, entry.abilityType);
        var targetPattern = makeTargetPattern(entry.targetPattern, db);
        switch (abilityType) {
            case AbilityType.heal: {
                return new HealAbility(targetPattern);
            }
            default: {
                throw new Exception('Unknown ability $abilityType');
            }
        }
    }

    static function makeEffect(id:String, db:FruitonDatabase): Effect{
        var entry:EffectModel = db.getEffect(id);
        var triggerType:TriggerType = Type.createEnum(TriggerType, entry.trigger);
        var effectType:EffectType = Type.createEnum(EffectType, entry.effect);
        var innerEffect:Effect;
        switch (effectType) {
            case EffectType.lowerAttack: {
                innerEffect = new LoweredAttackEffect(entry.params[0]);
            }
            default: {
                throw new Exception('Unknown effect $effectType');
            }
        }
        var targetPatternId = entry.targetPattern;
        var targetPattern = makeTargetPattern(targetPatternId, db);
        switch (triggerType) {
            case TriggerType.onAttack: {
                return new OnAttackTrigger(innerEffect, targetPattern);
            }
            case TriggerType.onDeath: {
                return new OnDeathTrigger(innerEffect, targetPattern);
            }
            default: {
                throw new Exception('Unknown trigger $triggerType');
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
            default: {
                throw new Exception('Unknown target pattern $type');
            }
        }
    }
}