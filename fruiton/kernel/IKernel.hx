package fruiton.kernel;

import fruiton.kernel.actions.Action;
import fruiton.kernel.events.Event;
import fruiton.dataStructures.Vector2;

typedef Actions = Array<Action>;
typedef Events = Array<Event>;

interface IKernel {

    function getAllValidActions():Actions;
    function getAllValidActionsFrom(position:Vector2):Actions;
    function performAction(action:Action):Events;
}