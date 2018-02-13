package fruiton.kernel.events;

import fruiton.dataStructures.Vector2;

class DeathEvent extends Event {

    public var fruiton(default, null):Fruiton;

    public function new(id:Int, fruiton:Fruiton) {
        super(id);
        this.fruiton = fruiton;
    }

    override public function toString():String {
        return super.toString() + " DeathEvent Fruiton: " + fruiton.toString();
    }
}