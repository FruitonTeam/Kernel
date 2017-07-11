package fruiton.kernel.events;

class MoveEvent extends Event {

    public var from(default, null):Position;
    public var to(default, null):Position;

    public function new(id:Int, from:Position, to:Position) {
        super(id);
        this.from = from;
        this.to = to;
    }

    override public function toString():String {
        return super.toString() + " MoveEvent From: " + Std.string(from) + " To: " + Std.string(to);
    }
}