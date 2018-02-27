package fruiton.kernel;

import fruiton.kernel.actions.MoveAction;
import fruiton.kernel.actions.MoveActionContext;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.targetPatterns.TargetPattern.Targets;
import fruiton.dataStructures.Vector2;
import haxe.Serializer;
import haxe.Unserializer;

typedef Moves = Array<MoveAction>;

/**
 * Immutable class representing movement pattern
 */
class MoveGenerator implements IHashable {

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
     * Generates all moves from origin by current TargetPattern
     * @param origin - where all moves start (where fruiton stands)
     * @return Moves generated according to TargetPattern
     */
    public function getMoves(origin:Vector2):Moves {
        var moves:Moves = new Moves();
        var positions:Targets = pattern.getTargets(origin);

        for (pos in positions ) {
            moves.push(new MoveAction(new MoveActionContext(origin, pos)));
        }

        return moves;
    }

    public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 +  pattern.getHashCode();
        return hash;
    }

    public function toString():String {
        return pattern.toString();
    }
}