package fruiton.kernel.effects;

import fruiton.kernel.effects.contexts.EffectContext;
import fruiton.kernel.events.ModifyAttackEvent;
import fruiton.kernel.events.ModifyHealthEvent;
import haxe.Serializer;
import haxe.Unserializer;

class ChangedStatsEffect extends Effect {

    var attackChange:Int;
    var healthChange:Int;

    @:keep
    override function hxSerialize(s:Serializer) {
        super.hxSerialize(s);
        s.serialize(attackChange);
        s.serialize(healthChange);
    }

    @:keep
    override function hxUnerialize(u:Unserializer) {
        super.hxUnerialize(u);
        attackChange = u.unserialize();
        healthChange = u.unserialize();
    }

    public function new(fruitonId:Int, attackChange:Int, healthChange:Int, text:String = ""){
        super(fruitonId, text);
        this.attackChange = attackChange;
        this.healthChange = healthChange;
    }

    override public function tryAddEffect(context: EffectContext, state: GameState, result:ActionExecutionResult) : Bool {
        var target = state.field.get(context.target).fruiton;
        var currentAttack = target.currentAttributes.damage;
        var currentHealth = target.currentAttributes.hp;
        var newAttack = cast Math.max(0, currentAttack + attackChange);
        var newHealth = currentHealth + healthChange;
        target.currentAttributes.damage = newAttack;
        target.currentAttributes.hp = newHealth;
        result.events.push(new ModifyAttackEvent(1, target.position, newAttack));
        result.events.push(new ModifyHealthEvent(2, target.position, newHealth));
        return true;
    }

    override public function tryRemoveEffect(context: EffectContext, state: GameState, result:ActionExecutionResult) : Bool {
        var target = state.field.get(context.target).fruiton;
        if (target != null) {
            target.currentAttributes.damage -= attackChange;
            target.currentAttributes.hp -= healthChange;
        }
        return true;
    }

    override public function equalsTo(other:Effect):Bool {
        if (other == null) {
            return false;
        }
        if (!Std.is(other, ChangedStatsEffect)) {
            return false;
        }

        var otherEffect = cast(other, ChangedStatsEffect);

        return this.attackChange == otherEffect.attackChange &&
               this.healthChange == otherEffect.healthChange;
    }

    override public function getHashCode():Int {
        var p0 = HashHelper.PRIME_0;
        var p1 = HashHelper.PRIME_1;

        var hash = p0 * HashHelper.hashString(Type.getClassName(Type.getClass(this)));
        hash = hash * p1 + attackChange;
        hash = hash * p1 + healthChange;
        return hash;
    }

    override function clone():Effect {
        return new ChangedStatsEffect(fruitonId, attackChange, healthChange, text);
    }
}