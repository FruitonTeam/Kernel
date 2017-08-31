package fruiton.kernel.fruitonTeam;

class ValidationMessage {

    public var success(default, null):Bool;
    public var message(default, null):String;

    public function new(success:Bool, message:String) {
        this.success = success;
        this.message = message;
    }
}