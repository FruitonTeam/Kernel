package fruiton.kernel;

import fruiton.kernel.actions.AttackAction;
import fruiton.kernel.actions.AttackActionContext;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.targetPatterns.TargetPattern.Targets;
import fruiton.dataStructures.Vector2;
import haxe.Serializer;
import haxe.Unserializer;

typedef Attacks = Array<AttackAction>;

/**
 * Immutable class representing a way of attacking
 */
class AttackGenerator implements IHashable {

    var pattern:TargetPattern;

    @:keep
    function hxSerialize(s:Serializer) {
        s.serialize(pattern);
    }

    @:keep
    function hxUnserialize(u:Unserializer) {
        pattern = u.unserialize();
    }

    public function new(targetPattern:TargetPattern) {
        this.pattern = targetPattern;
    }

    /**
     * Generates all attacks from orgin by current TargetPattern
     * @param origin - where all attack start (where fruiton stands)
     * @return Attacks generated according to TargetPattern
     */
    public function getAttacks(origin:Vector2, damage:Int):Attacks {
        var attacks:Attacks = new Attacks();
        var positions:Targets = pattern.getTargets(origin);

        for (pos in positions ) {
            attacks.push(new AttackAction(new AttackActionContext(damage, origin, pos)));
        }

        return attacks;
    }

    public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 + pattern.getHashCode();
        return hash;
    }

    public function toString():String {
        return pattern.toString();
    }
}