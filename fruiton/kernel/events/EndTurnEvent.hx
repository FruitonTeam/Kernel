package fruiton.kernel.events;

class EndTurnEvent extends Event {

    public function new(id:Int) {
        super(id);
    }

    override public function toString():String {
        return super.toString() + " EndTurnEvent";
    }
}
