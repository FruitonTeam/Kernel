package fruiton.kernel.events;

import fruiton.dataStructures.Vector2;

class DeathEvent extends Event {

    public var target(default, null):Vector2;

    public function new(id:Int, target:Vector2) {
        super(id);
        this.target = target;
    }

    override public function toString():String {
        return super.toString() + " DeathEvent Target: " + Std.string(target);
    }
}