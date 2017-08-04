package fruiton.kernel.events;

import fruiton.IAbstractClass;

class Event implements IAbstractClass {
    
    public var id(default, null):Int;

    public function new(id:Int) {
        this.id = id;
    }

    public function toString():String {
        return "Event id: " + id;
    }
}