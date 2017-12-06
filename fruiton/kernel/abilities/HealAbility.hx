package fruiton.kernel.abilities;

import fruiton.kernel.targetPatterns.TargetPattern;
import fruiton.kernel.actions.Action;
import fruiton.kernel.abilities.Ability;
import fruiton.dataStructures.Vector2;
import fruiton.kernel.actions.HealAction;
import fruiton.kernel.actions.HealActionContext;
import fruiton.kernel.Fruiton;

class HealAbility extends Ability {

    public function new(targetPattern:TargetPattern) {
        super(targetPattern);
    }
    
    override public function getActions(origin:Vector2, fruiton:Fruiton):Actions {
        var healActions:Actions = new Actions();
        var positions:Targets = pattern.getTargets(origin);

        for (pos in positions) {
            healActions.push(new HealAction(new HealActionContext(fruiton.currentAttributes.heal, origin, pos)));
        }

        return healActions;
    }
}