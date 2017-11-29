package fruiton.kernel.effects.triggers;

import fruiton.kernel.effects.Effect;

class Trigger extends Effect  {

    var effect:Effect;

    function new(effect:Effect) {
        super();
        this.effect = effect;
    }
}