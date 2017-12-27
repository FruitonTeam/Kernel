package fruiton.kernel.events;

import fruiton.dataStructures.Vector2;

class ModifyHealthEvent extends Event {

    public var position(default, null):Vector2;
    public var newHealth(default, null):Int;

    public function new(id:Int, position:Vector2, newHealth:Int) {
        super(id);
        this.position = position;
        this.newHealth = newHealth;
    }

    override public function toString():String {
        return super.toString() + " ModifyHealth Position: " + Std.string(position) + " NewHealth: " + Std.string(newHealth);
    }
}