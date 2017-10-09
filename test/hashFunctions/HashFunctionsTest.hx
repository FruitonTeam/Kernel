package test.hashFunctions;

import sys.io.File;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.targetPatterns.LineTargetPattern;
import fruiton.kernel.targetPatterns.RangeTargetPattern;
import fruiton.kernel.AttackGenerator;
import fruiton.kernel.Player;
import fruiton.kernel.MoveGenerator;
import fruiton.kernel.Fruiton;
import fruiton.kernel.TurnState;
import fruiton.kernel.GameState;
import fruiton.HashHelper;
import massive.munit.Assert;

class HashFunctionsTest {

    public function new() {}

    @BeforeClass
    public function beforeClass() {
        Sys.println("======================");
        Sys.println("Hash functions tests");
        Sys.println("======================");
    }

    @Test
    public function hashFunctions_byDefault_returnInt() {
        Sys.println("=== running hashFunctions_byDefault_returnInt");

        var vector2: Vector2 = new Vector2(0, 0);
        var lineTargetPattern: LineTargetPattern = new LineTargetPattern(vector2, 1, 0);
        var attackGenerator: AttackGenerator = new AttackGenerator(lineTargetPattern, 1);
        var player: Player = new Player(0);
        var moveGenerator: MoveGenerator = new MoveGenerator(lineTargetPattern);
        var fruiton: Fruiton = new Fruiton(0, vector2, player, 2, "model1", [], [], 0);
        var gameState: GameState = new GameState([player], 0, [fruiton]);

        Assert.isType(vector2.getHashCode(), Int);
        Assert.isType(lineTargetPattern.getHashCode(), Int);
        Assert.isType(new RangeTargetPattern(vector2, 1, 0).getHashCode(), Int);
        Assert.isType(attackGenerator.getHashCode(), Int);
        Assert.isType(player.getHashCode(), Int);
        Assert.isType(moveGenerator.getHashCode(), Int);
        Assert.isType(new TurnState().getHashCode(), Int);
        Assert.isType(fruiton.getHashCode(), Int);
        Assert.isType(gameState.getHashCode(), Int);
        Assert.isType(HashHelper.hashString("aaa"), Int);
        Assert.isType(HashHelper.hashIterable([player]), Int);

    }

    @Test
    public function hashIterable_switchElementOrder_returnDifferentHash() {
        Sys.println("=== running hashIterable_switchElementOrder_returnDifferentHash");

        var player1: Player = new Player(0);
        var player2: Player = new Player(1);

        Assert.areNotEqual(player1.getHashCode(), player2.getHashCode());

        Assert.areNotEqual(
            HashHelper.hashIterable([player1, player2]),
            HashHelper.hashIterable([player2, player1])
            );
    }
}