package fruiton.kernel.abilities;

import fruiton.IAbstractClass;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.Fruiton;
import fruiton.kernel.IKernel;

class Ability implements IAbstractClass {

    var pattern:TargetPattern;
    var text:String;

    function new(targetPattern:TargetPattern, text:String = "") {
        this.pattern = targetPattern;
        this.text = text;
    }

    public function getActions(origin:Vector2, fruiton:Fruiton):IKernel.Actions;
}