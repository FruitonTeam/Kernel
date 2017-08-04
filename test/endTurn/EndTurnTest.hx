package test.endTurn;

import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.Fruiton.MoveGenerators;
import fruiton.kernel.targetPatterns.*;
import fruiton.dataStructures.*;

class EndTurnTest {

    public function new() {}

    @BeforeClass
	public function beforeClass() {
		Sys.println("==============");
        Sys.println("End turn tests");
        Sys.println("==============");
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
		var fruiton:Fruiton = new Fruiton(1, new Vector2(0, 1), p1, moveGenerators);
		return new Kernel(p1, p2, [fruiton]);
	}

    @Test
    public function kerel_performEndTurnAction_returnsOneEndTurnEvent() {
        Sys.println("=== running kerel_performEndTurnAction_returnsOneEndTurnEvent");
        var kernel:Kernel = makeKernel();

        var events:IKernel.Events = kernel.performAction(new EndTurnAction(new EndTurnActionContext()));

        var endTurnEvent:EndTurnEvent = null;
        // There may be more events associated with turn ending
        // Fruitons may evolve, take periodical damage etc.
        for (event in events) {
            if (Std.is(event, EndTurnEvent)) {
                // There is no more than one EndTurnEvent
                Assert.isNull(endTurnEvent);
                endTurnEvent = cast(event, EndTurnEvent);
            }
        }

        // There is at least one EndTurnEvent
        Assert.isNotNull(endTurnEvent);
    }

    @Test
    public function getAllValidActions_byDefault_returnsOneEndTurnAction() {
        Sys.println("=== running getAllValidActions_byDefault_returnsOneEndTurnAction");
        var kernel:Kernel = makeKernel();
        var actions:IKernel.Actions = kernel.getAllValidActions();

        var endTurnAction:EndTurnAction = null;
        for (action in actions) {
            if (Std.is(action, EndTurnAction)) {
                kernel.performAction(action);
                // There is no more than one EndTurnAction
                Assert.isNull(endTurnAction);
                endTurnAction = cast(action, EndTurnAction);
            }
        }

        // There is at least one EndTurnAction
        Assert.isNotNull(endTurnAction);
    }

    @Test
    public function kernel_performEndTurnAction_switchesPlayer() {
        Sys.println("=== running kernel_performEndTurnAction_switchesPlayer");
        var kernel:Kernel = makeKernel();

        var p1:Player = kernel.currentState.activePlayer;
        kernel.performAction(new EndTurnAction(new EndTurnActionContext()));
        var p2:Player = kernel.currentState.activePlayer;

        Assert.isFalse(p1.equals(p2));
    }

    @Test
    public function kernel_performEndTurnActionTwice_switchesPlayerBack() {
        Sys.println("=== running kernel_performEndTurnActionTwice_switchesPlayerBack");

        var kernel:Kernel = makeKernel();

        var p1:Player = kernel.currentState.activePlayer;
        kernel.performAction(new EndTurnAction(new EndTurnActionContext()));
        kernel.performAction(new EndTurnAction(new EndTurnActionContext()));
        var p1Again:Player = kernel.currentState.activePlayer;

        Assert.isTrue(p1.equals(p1Again));
    }
}
