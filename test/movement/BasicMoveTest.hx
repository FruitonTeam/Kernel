package test.movement;

import massive.munit.util.Timer;
import massive.munit.Assert;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.exceptions.InvalidActionException;

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
		var fruiton:Fruiton = new Fruiton(1, new Position(0, 1), p1);
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
		for (i in 0...3) {
			testAction(i);
		}
	}

	function testAction(idx:Int) {
		// Setup
		var kernel:IKernel = makeKernel();
		var k:Kernel = cast(kernel, Kernel);
		var actions:IKernel.Actions = kernel.getAllValidActions();
		
		trace("All valid actions:");
		for (act in actions) {
			trace(Std.string(act));
		}

		//printField(k.currentState.field);
		
		// Run
		var a:Action = actions[idx];
		trace("Performing action: " + Std.string(a));
        var events:Array<Event> = kernel.performAction(a);
		
		//printField(k.currentState.field);

		// Assert
		Assert.areEqual(events.length, 1);
		var me:MoveEvent = cast (events[0], MoveEvent);
		var ma:MoveAction = cast (a, MoveAction);
		Assert.isTrue(me.from.equals(new Position(0, 1)));
		Assert.isTrue(me.to.equals(ma.actionContext.target));
		trace(Std.string(events[0]));
	}

	function printField(field:Field) {
		for (x in 0...GameState.WIDTH) {
			var line:String = "";
			for (y in 0...GameState.HEIGHT) {
				var fruiton:Fruiton = field.get(new Position(x, y)).fruiton;
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
}
