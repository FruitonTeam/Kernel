package test.movement;

import massive.munit.util.Timer;
import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.Fruiton.MoveGenerators;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.targetPatterns.*;
import fruiton.kernel.exceptions.InvalidActionException;
import fruiton.dataStructures.*;

class BasicMoveTest {

	var timer:Timer;
	
	public function new() {}
	
	@BeforeClass
	public function beforeClass() {
		Sys.println("====================");
		Sys.println("Basic movement tests"); 
		Sys.println("====================");
	}
	
	@AfterClass
	public function afterClass() {}
	
	@Before
	public function setup() {}
	
	@After
	public function tearDown() {}

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
    public function testInvalidAction() {
        try {
			var kernel:IKernel = makeKernel();
			var a:Action = new MoveAction(new MoveActionContext(null, null));
			kernel.performAction(a);
		} 
		catch (e : InvalidActionException) {
			// Expected behavior
		}
    }

	@Test
	public function testNullAction() {
		try {
			var kernel:IKernel = makeKernel();
			kernel.performAction(null);
		} 
		catch (e : InvalidActionException) {
			// Expected behavior
		}
	}

	@Test
	public function testValidAction() {
		var i:Int = 0;
		while(true) {
			var p1:Player = new Player(1);
			var p2:Player = new Player(2);
			var moveGenerators:MoveGenerators = new MoveGenerators();
			moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(0, 1), -1, 1)));
			moveGenerators.push(new MoveGenerator(new LineTargetPattern(new Vector2(1, 0), -1, 1)));
			var fruitonPos:Vector2 = new Vector2(0, 1);
			var fruiton:Fruiton = new Fruiton(1, fruitonPos, p1, moveGenerators);
			var kernel:IKernel = new Kernel(p1, p2, [fruiton]);
			var k:Kernel = cast(kernel, Kernel);

			if (!testAction(i, k, fruitonPos)) {
				break;
			}

			++i;
		}
	}

	function printField(field:Field) {
		for (x in 0...GameState.WIDTH) {
			var line:String = "";
			for (y in 0...GameState.HEIGHT) {
				var fruiton:Fruiton = field.get(new Vector2(x, y)).fruiton;
				if (fruiton == null) {
					line += " . ";
				}
				else {
					line += " " + fruiton.id + " ";
				}
			}
			Sys.println(line);
		}
	}

	@Test
	public function testAllRangeActions() {
		var i:Int = 0;
		while(true) {
			var p1:Player = new Player(1);
			var p2:Player = new Player(2);
			var moveGenerators:MoveGenerators = new MoveGenerators();
			moveGenerators.push(new MoveGenerator(new RangeTargetPattern(null, 0, 1)));
			var fruitonPos:Vector2 = new Vector2(1, 1);
			var fruiton:Fruiton = new Fruiton(1, fruitonPos, p1, moveGenerators);
			var kernel:IKernel = new Kernel(p1, p2, [fruiton]);
			var k:Kernel = cast(kernel, Kernel);

			if (!testAction(i, k, fruitonPos)) {
				break;
			}

			++i;
		}
	}

	function testAction(idx:Int, k:Kernel, fruitonPos:Vector2):Bool {
		Sys.println("--- Testing action [" + idx + "]");

		var actions:IKernel.Actions = k.getAllValidActions();

		if (idx >= actions.length ||
			!Std.is(actions[idx], MoveAction)) {
			return false;
		}

		trace("All valid actions:");
		for (act in actions) {
			trace(Std.string(act));
		}

		//printField(k.currentState.field);
		
		// Run
		var a:Action = actions[idx];
		trace("Performing action: " + Std.string(a));
        var events:Array<Event> = k.performAction(a);
		
		//printField(k.currentState.field);

		// Assert
		Assert.areEqual(events.length, 1);
		var me:MoveEvent = cast (events[0], MoveEvent);
		var ma:MoveAction = cast (a, MoveAction);
		Assert.isTrue(me.from == fruitonPos);
		Assert.isTrue(me.to == ma.actionContext.target);
		trace(Std.string(events[0]));

		trace("Source fruiton: " + Std.string(k.currentState.field.get(new Vector2(0, 1)).fruiton));
		trace("Terget fruiton: " + Std.string(k.currentState.field.get(new Vector2(1, 1)).fruiton));

		return true;
	}
}