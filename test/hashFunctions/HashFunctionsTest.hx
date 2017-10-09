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