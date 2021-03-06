package fruiton.kernel.effects;

import fruiton.kernel.exceptions.Exception;
import fruiton.kernel.actions.AttackAction;
import fruiton.kernel.actions.HealAction;
import fruiton.kernel.effects.contexts.EffectContext;
import haxe.Serializer;
import haxe.Unserializer;

class ImmunityEffect extends Effect {

    var immunityId : Int;

    @:keep
    override function hxSerialize(s:Serializer) {
        super.hxSerialize(s);
        s.serialize(immunityId);
    }

    @:keep
    override function hxUnserialize(u:Unserializer) {
        super.hxUnserialize(u);
        immunityId = u.unserialize();
    }

    public function new(fruitonId:Int, immunityId: Int, text:String = "") {
        this.immunityId = immunityId;
        super(fruitonId, text);
    }

    override public function tryAddEffect(context: EffectContext, state: GameState, result:ActionExecutionResult) : Bool {
        var target = state.field.get(context.target).fruiton;
        target.currentAttributes.addImunity(immunityId);
        return true;
    }

    override public function tryRemoveEffect(context: EffectContext, state: GameState, result:ActionExecutionResult) : Bool {
        var target = state.field.get(context.target).fruiton;
        target.currentAttributes.removeImunity(immunityId);
        return true;
    }

    override public function equalsTo(other:Effect):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, ImmunityEffect)) {
            return false;
        }

        var otherEffect = cast(other, ImmunityEffect);

        return immunityId == otherEffect.immunityId;
    }

    override public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 + immunityId;
        return hash;
    }

    override function clone():Effect {
        return new ImmunityEffect(fruitonId, immunityId, text);
    }

    override function getDescription():String {
        var immunityName:String;
        switch (immunityId) {
            case AttackAction.ID:
                immunityName = "attack";
            case HealAction.ID:
                immunityName = "heal";
            default:
                throw new Exception('Unknown immunity id $immunityId');
        }
        return 'Immune to $immunityName.';
    }
}