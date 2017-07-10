package fruiton.kernel;

interface IKernel {

    function getAllValidActions():Array<Action>;
    function performAction(action:Action):Array<Event>;
}