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
import fruiton.kernel.exceptions.*;

class AttackRulesTest {

    @BeforeClass
	public function beforeClass() {
		Sys.println("==================");
        Sys.println("Attack rules tests");
        Sys.println("==================");
	}

    @Test
    function performAction_attackActionWithHigherDmg_throwsInvalidActionException() {
        Sys.println("=== running performAction_attackActionWithHigherDmg_throwsInvalidActionException");

        var kernel = AttackTest.makeKernel(false);
        var attackAction = Hlinq.firstOfTypeOrNull(kernel.getAllValidActions(), AttackAction);

        attackAction.actionContext.damage *= 2;

        try {
            kernel.performAction(attackAction);
        } catch (e : InvalidActionException) {
            // Expected behavior
            return;
        }

        Assert.isTrue(false);
    }
}