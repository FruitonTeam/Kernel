package fruiton.kernel.gameModes;

class StandardGameMode extends GameMode {

    public function new() {
    }

    override public function checkGameOver(gameState:GameState):Bool {
        var losers:Array<Int> = [for (p in gameState.players) p.id];
        for (fruiton in gameState.fruitons) {
            if (fruiton.isKing) {
                losers.remove(fruiton.owner.id);
            }
        }

        for (loser in losers) {
            gameState.losers.push(loser);
        }

        return losers.length > 0;
    }

    override public function clone():GameMode {
        return new StandardGameMode();
    }
}