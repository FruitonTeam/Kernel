package fruiton.kernel.abilities;

import fruiton.IAbstractClass;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.Fruiton;
import fruiton.kernel.IKernel;

class Ability implements IAbstractClass {

    var pattern:TargetPattern;

    function new(targetPattern:TargetPattern) {
        this.pattern = targetPattern;
    }

    public function getActions(origin:Vector2, fruiton:Fruiton):IKernel.Actions;

}