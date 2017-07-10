package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import fruiton.kernel.*;
import fruiton.kernel.exceptions.InvalidActionException;

class BasicMoveTest 
{
	private var timer:Timer;
	
	public function new() {
	}
	
	@BeforeClass
	public function beforeClass():Void {
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
			var kernel:IKernel = new Kernel();
			var a:Action = new MoveAction(null, null);
			kernel.performAction(a);
		} catch (e : InvalidActionException) {
			// Expected behavior
		}
    }

	@Test
	public function testNullAction():Void {
		try {
			var kernel:IKernel = new Kernel();
			kernel.performAction(null);
		} catch (e : InvalidActionException) {
			// Expected behavior
		}
	}

	@Test
	public function testValidAction():Void
	{
		var kernel:IKernel = new Kernel();
        var source:Tile = new Tile(new Position(0,0));
        var target:Tile = new Tile(new Position(0,1));
        source.fruiton = new Fruiton(1);

        var a:Action = new MoveAction(source, target);
        var events:Array<Event> = kernel.performAction(a);
		Assert.isTrue(events != null);
	}
}