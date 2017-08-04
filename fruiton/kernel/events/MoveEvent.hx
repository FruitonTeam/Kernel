package fruiton.kernel.events;

import fruiton.dataStructures.Vector2;

class MoveEvent extends Event {

    public var from(default, null):Vector2;
    public var to(default, null):Vector2;

    public function new(id:Int, from:Vector2, to:Vector2) {
        super(id);
        this.from = from;
        this.to = to;
    }

    override public function toString():String {
        return super.toString() + " MoveEvent From: " + Std.string(from) + " To: " + Std.string(to);
    }
}