package fruiton.kernel.abilities;

import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.actions.HealAction;
import fruiton.kernel.actions.HealActionContext;
import fruiton.kernel.Fruiton;

class HealAbility extends Ability {

    public function new(targetPattern:TargetPattern, text:String) {
        super(targetPattern, text);
    }

    override public function getActions(origin:Vector2, fruiton:Fruiton):IKernel.Actions {
        var healActions = new IKernel.Actions();
        var positions:Targets = pattern.getTargets(origin);

        for (pos in positions) {
            healActions.push(new HealAction(new HealActionContext(fruiton.currentAttributes.heal, origin, pos)));
        }

        return healActions;
    }
}