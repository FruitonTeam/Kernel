package fruiton.kernel.fruitonTeam;

class ValidationResult {

    public var complete(default, null):Bool;
    public var valid(default, null):Bool;

    public function new(valid:Bool, complete:Bool) {
        this.complete = complete;
        this.valid = valid;
    }
}