package fruiton.kernel.effects.triggers;

import fruiton.kernel.effects.Effect;

class Trigger extends Effect  {

    var effect:Effect;

    function new(fruitonId, effect:Effect) {
        super(fruitonId);
        this.effect = effect;
    }
}