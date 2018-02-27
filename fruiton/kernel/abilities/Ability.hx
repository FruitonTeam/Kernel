package fruiton.kernel.abilities;

import fruiton.IAbstractClass;
import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.Fruiton;
import fruiton.kernel.IKernel;
import haxe.Serializer;
import haxe.Unserializer;

class Ability implements IAbstractClass {

    var pattern:TargetPattern;
    var text:String;

    @:keep
    function hxSerialize(s:Serializer) {
        s.serialize(pattern);
        s.serialize(text);
    }

    @:keep
    function hxUnserialize(u:Unserializer) {
        pattern = u.unserialize();
        text = u.unserialize();
    }

    function new(targetPattern:TargetPattern, text:String = "") {
        this.pattern = targetPattern;
        this.text = text;
    }

    public function getActions(origin:Vector2, fruiton:Fruiton):IKernel.Actions;
}