package fruiton.kernel.exceptions;

class InvalidActionException extends Exception {
    
    public function new(message:String) {
        super(message);
    }
}