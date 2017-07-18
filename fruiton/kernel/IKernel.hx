package fruiton.kernel;

import fruiton.kernel.actions.Action;
import fruiton.kernel.events.Event;

typedef Actions = Array<Action>;
typedef Events = Array<Event>;

interface IKernel {

    function getAllValidActions():Actions;
    function performAction(action:Action):Events;
}