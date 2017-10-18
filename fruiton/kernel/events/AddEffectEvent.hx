package fruiton.kernel.events;

import fruiton.dataStructures.Vector2;

class AddEffectEvent extends Event {

    public var source(default, null):Vector2;
    public var target(default, null):Vector2;
    public var name(default, null):String;

    public function new(id:Int, source:Vector2, target:Vector2, damage:Int) {
        super(id);
        this.source = source;
        this.target = target;
        this.name = damage;
    }

    override public function toString():String {
        return super.toString() + " EffectAddedEvent Source: " + Std.string(source) + " Target: " + Std.string(target) + " Damage: " + Std.string(name);
    }
}