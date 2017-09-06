package fruiton.kernel.events;

class GameOverEvent extends Event {

    public var losers(default, null):Array<Int>;

    public function new(id:Int, losers:Array<Int>) {
        super(id);
        this.losers = losers.copy();
    }

    override public function toString():String {
        return super.toString() + " GameOverEvent Losers: " + Std.string(losers);
    }
}