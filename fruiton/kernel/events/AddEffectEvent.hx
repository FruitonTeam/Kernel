package fruiton.kernel.events;

import fruiton.dataStructures.Vector2;

class AddEffectEvent extends Event {

    public var source(default, null):Vector2;
    public var target(default, null):Vector2;

    public function new(id:Int, source:Vector2, target:Vector2) {
        super(id);
        this.source = source;
        this.target = target;
    }

    override public function toString():String {
        return super.toString() + " AddEffectEvent Source: " + Std.string(source) + " Target: " + Std.string(target);
    }
}