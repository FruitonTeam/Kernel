package fruiton.dataStructures.collections;

class ReadOnlyArray<T> {

    var source:Array<T>;

    public function new(source) {
        this.source = source.copy();
    }

    public function get(index):T {
        return source[index];
    }

    public function iterator():Iterator<T> {
        return source.iterator();
    }

    public function shallowCopyToArray():Array<T> {
        return source.copy();
    }
}