package fruiton.kernel.exceptions;

class Exception {
    
    public var message(default, null):String;

    public function new(message:String) {
        this.message = message;
    }
}