package fruiton.dataStructures;

class FruitonAttributes {

    public var hp:Int;
    public var damage:Int;

    public function new(hp:Int, damage:Int) {
        this.hp = hp;
        this.damage = damage;
    }

    public function clone():FruitonAttributes {
        return new FruitonAttributes(this.hp, this.damage);
    }
}