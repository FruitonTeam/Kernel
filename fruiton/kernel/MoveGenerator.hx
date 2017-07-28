package fruiton.kernel;

import fruiton.kernel.actions.MoveAction;
import fruiton.kernel.actions.MoveActionContext;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.targetPatterns.TargetPattern.Targets;

typedef Moves = Array<MoveAction>;

/**
 *  Immutable class representing movement pattern
 */
class MoveGenerator {

    var pattern:TargetPattern;

    public function new(targetPattern:TargetPattern) {
        this.pattern = targetPattern;
    }

    /**
     *  Generates all moves from orgin by current TargetPattern
     *  @param origin - where all moves start (where fruiton stands)
     *  @return Moves generated according to TargetPattern
     */
    public function getMoves(origin:Position):Moves {
        var moves:Moves = new Moves();
        var positions:Targets = pattern.getTargets(origin);

        for (pos in positions ) {
            moves.push(new MoveAction(new MoveActionContext(origin, pos)));
        }

        return moves;
    }
}