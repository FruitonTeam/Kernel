package fruiton.kernel.gameModes;

class LastManStandingGameMode extends GameMode {

    public function new() {
    }

    override public function checkGameOver(gameState:GameState):Bool {
        var losers:Array<Int> = [for (p in gameState.players) p.id];
        for (fruiton in gameState.fruitons) {
            losers.remove(fruiton.owner.id);
        }

        for (loser in losers) {
            gameState.losers.push(loser);
        }

        return losers.length > 0;
    }
}