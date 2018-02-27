package fruiton.kernel.events;

import fruiton.dataStructures.Vector2;

class ModifyAttackEvent extends Event {

    public var position(default, null):Vector2;
    public var newAttack(default, null):Int;

    public function new(id:Int, position:Vector2, newAttack:Int) {
        super(id);
        this.position = position;
        this.newAttack = newAttack;
    }

    override public function toString():String {
        return super.toString() + " ModifyAttack Position: " + Std.string(position) + " NewAttack: " + Std.string(newAttack);
    }
}