package fruiton.kernel;

import fruiton.kernel.actions.AttackAction;
import fruiton.kernel.actions.AttackActionContext;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.targetPatterns.TargetPattern.Targets;
import fruiton.dataStructures.Vector2;

typedef Attacks = Array<AttackAction>;

/**
 * Immutable class representing a way of attacking
 */
class AttackGenerator {

    var pattern:TargetPattern;
    var damage:Int;

    public function new(targetPattern:TargetPattern, damage:Int) {
        this.pattern = targetPattern;
    }

    /**
     * Generates all attacks from orgin by current TargetPattern
     * @param origin - where all attack start (where fruiton stands)
     * @return Attacks generated according to TargetPattern
     */
    public function getAttacks(origin:Vector2):Attacks {
        var attacks:Attacks = new Attacks();
        var positions:Targets = pattern.getTargets(origin);

        for (pos in positions ) {
            attacks.push(new AttackAction(new AttackActionContext(damage, origin, pos)));
        }

        return attacks;
    }
}