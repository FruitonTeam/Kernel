package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import fruiton.kernel.Kernel;
import fruiton.kernel.*;
import fruiton.kernel.actions.*;
import fruiton.kernel.events.*;
import fruiton.kernel.exceptions.InvalidActionException;

class BasicMoveTest 
{
	private var timer:Timer;
	
	public function new() {
	}
	
	@BeforeClass
	public function beforeClass():Void {
		// Avoid later print statements being intercepted by "Tests PASSED under ..." message
		// To see try to comment following
		Sys.println(""); Sys.println(""); Sys.println("");
	}
	
	@AfterClass
	public function afterClass():Void {
	}
	
	@Before
	public function setup():Void {
	}
	
	@After
	public function tearDown():Void {
	}
	
    @Test
    public function testInvalidAction():Void {
        try {
			var kernel:IKernel = new Kernel(new Player(1), new Player(2), []);
			var a:Action = new MoveAction(null, null);
			kernel.performAction(a);
		} catch (e : InvalidActionException) {
			// Expected behavior
		}
    }

	@Test
	public function testNullAction():Void {
		try {
			var kernel:IKernel = new Kernel(new Player(1), new Player(2), []);
			kernel.performAction(null);
		} catch (e : InvalidActionException) {
			// Expected behavior
		}
	}

	@Test
	public function testValidAction():Void
	{
		// Setup
		var p1:Player = new Player(1);
		var p2:Player = new Player(2);
		var fruiton:Fruiton = new Fruiton(1, new Position(0, 1), p1);
		var kernel:IKernel = new Kernel(p1, p2, [fruiton]);
		var k:Kernel = cast(kernel, Kernel);
		var a:Action = new MoveAction(fruiton.position, new Position(1, 1));

		printField(k.currentState.field);
		
		// Run
        var events:Array<Event> = kernel.performAction(a);
		
		printField(k.currentState.field);

		// Assert
		Assert.areEqual(events.length, 1);
		var me:MoveEvent = cast (events[0], MoveEvent);
		Assert.isTrue(me.from.equals(new Position(0, 1)));
		Assert.isTrue(me.to.equals(new Position(1, 1)));
		trace(Std.string(events[0]));
		trace("Source fruiton: " + Std.string(k.currentState.field.get(new Position(0, 1)).fruiton));
		trace("Terget fruiton: " + Std.string(k.currentState.field.get(new Position(1, 1)).fruiton));
	}

	function printField(field:Field) {
		for(x in 0...GameState.WIDTH) {
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
