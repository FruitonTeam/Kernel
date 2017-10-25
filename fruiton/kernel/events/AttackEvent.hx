package fruiton.kernel.events;

import fruiton.dataStructures.Vector2;

class AttackEvent extends Event {

    public var source(default, null):Vector2;
    public var target(default, null):Vector2;
    public var damage(default, null):Int;

    public function new(id:Int, source:Vector2, target:Vector2, damage:Int) {
        super(id);
        this.source = source;
        this.target = target;
        this.damage = damage;
    }

    override public function toString():String {
        return super.toString() + " AttackEvent Source: " + Std.string(source) + " Target: " + Std.string(target) + " Damage: " + Std.string(damage);
    }
}