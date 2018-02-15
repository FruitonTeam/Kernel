package fruiton.kernel.effects.triggers;

import fruiton.kernel.effects.Effect;
import haxe.Serializer;
import haxe.Unserializer;

class Trigger extends Effect  {

    var effect:Effect;

    @:keep
    override function hxSerialize(s:Serializer) {
        super.hxSerialize(s);
        s.serialize(effect);
    }

    @:keep
    override function hxUnserialize(u:Unserializer) {
        super.hxUnserialize(u);
        effect = u.unserialize();
    }

    function new(fruitonId, effect:Effect, text:String = "") {
        super(fruitonId, text);
        this.effect = effect;
    }
}