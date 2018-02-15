package test.serialization;

import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.Fruiton.MoveGenerators;
import fruiton.kernel.Fruiton.AttackGenerators;
import fruiton.kernel.targetPatterns.*;
import fruiton.dataStructures.*;
import fruiton.kernel.abilities.HealAbility;
import haxe.Serializer;
import haxe.Unserializer;
import test.abilities.*;

class SerializationTest {

    @BeforeClass
    public function beforeClass() {
        Sys.println("===================");
        Sys.println("Serialization tests");
        Sys.println("===================");
    }

    @Test
    public function performHealAction_onUnserializedState_worksSameAsOnSerialized() {
        Sys.println("=== running performHealAction_onUnserializedState_worksSameAsOnSerialized");
        var k:Kernel = HealTest.makeKernel(6);

        var state = k.currentState;
        var serialized = state.serializeToString();
        Sys.println(serialized);

        // Do action once
        performAction(k);

        var newStateCorrect = k.currentState;

        // Reset state
        var serializedState:GameState = GameState.unserialize(serialized);
        k.currentState = serializedState;

        // Do action second time
        performAction(k);

        // TODO equalsTo is not implemented everywhere
        //Assert.isTrue(k.currentState.equalsTo(newCorrectState));
    }

    function performAction(k:Kernel) {
        var actions:IKernel.Actions = k.getAllValidActions();
		var action:HealAction = Hlinq.firstOfTypeOrNull(actions, HealAction);
		var result:IKernel.Events = k.performAction(action);
		var event:HealEvent = Hlinq.firstOfTypeOrNull(result, HealEvent);
        var healedFruiton:Fruiton = k.currentState.field.get(event.target).fruiton;
        var healingFruiton:Fruiton = k.currentState.field.get(event.source).fruiton;
        Assert.isTrue(event.heal == 5);
        Assert.isTrue(healedFruiton.currentAttributes.hp == 9);
        Assert.isTrue(healedFruiton.owner == healingFruiton.owner);
    }
}