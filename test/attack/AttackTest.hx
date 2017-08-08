package test.attack;

import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.Fruiton.MoveGenerators;
import fruiton.kernel.Fruiton.AttackGenerators;
import fruiton.kernel.targetPatterns.*;
import fruiton.dataStructures.*;

class AttackTest {

    public function new() {}

    @BeforeClass
	public function beforeClass() {
		Sys.println("============");
        Sys.println("Attack tests");
        Sys.println("============");
	}

    /**
     * Factory method for unified and simple kernel creation
     * @return Kernel which is initialized
     */
    function makeKernel():Kernel {
		var p1:Player = new Player(1);
		var p2:Player = new Player(2);

        var moveGenerators:MoveGenerators = new MoveGenerators();
        moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(0, 1), -1, 1)));
        moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1)));

        var attackGenerators:AttackGenerators = new AttackGenerators();
        attackGenerators.push(new AttackGenerator(new RangeTargetPattern(Vector2.ZERO, 0, 1), 5));
        attackGenerators.push(new AttackGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1), 5));

        var fruiton:Fruiton = new Fruiton(1, new Vector2(0, 1), p1, moveGenerators, attackGenerators);
		return new Kernel(p1, p2, [fruiton]);
	}

    @Test
    public function f() {

    }
}
