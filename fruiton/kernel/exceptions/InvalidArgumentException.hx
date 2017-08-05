package fruiton.kernel.exceptions;

class InvalidArgumentException extends Exception {

    public function new(message:String) {
        super(message);
    }
}