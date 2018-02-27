package fruiton.kernel.events;

import fruiton.dataStructures.Vector2;

class HealEvent extends Event {

    public var source(default, null):Vector2;
    public var target(default, null):Vector2;
    public var heal(default, null):Int;

    public function new(id:Int, source:Vector2, target:Vector2, heal:Int) {
        super(id);
        this.source = source;
        this.target = target;
        this.heal = heal;
    }

    override public function toString():String {
        return super.toString() + " HealEvent Source: " + Std.string(source) + " Target: " + Std.string(target) + " Damage: " + Std.string(heal);
    }
}