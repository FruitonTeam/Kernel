package fruiton.dataStructures;

class FruitonAttributes {

    public var hp:Int;
    public var damage:Int;
    public var heal:Int;
    public var immunities:Array<Int>;

    public function new(hp:Int, damage:Int, heal:Int = 0, ?immunities:Array<Int>) {
        this.hp = hp;
        this.damage = damage;
        this.heal = heal;
        if (immunities != null) {
            this.immunities = immunities;
        } else {
            this.immunities = [];
        }
    }

    public function addImunity(actionId:Int) {
        if (immunities.indexOf(actionId) == -1) {
            immunities.push(actionId);
        }
    }

    public function removeImunity(actionId:Int) {
        immunities.remove(actionId);
    }

    public function clone():FruitonAttributes {
        return new FruitonAttributes(this.hp, this.damage, this.heal, this.immunities);
    }
}