package fruiton.dataStructures;

class FruitonAttributes {

    public var hp:Int;
    public var damage:Int;
    public var heal:Int;

    public function new(hp:Int, damage:Int, heal:Int = 0) {
        this.hp = hp;
        this.damage = damage;
        this.heal = heal;
    }

    public function clone():FruitonAttributes {
        return new FruitonAttributes(this.hp, this.damage, this.heal);
    }
}