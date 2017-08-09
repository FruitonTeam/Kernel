package fruiton.dataStructures.collections;

/**
 * Standard array with useful extension methods
 */
@:forward
abstract ExtendedArray<T>(Array<T>)
from Array<T>
to Array<T> {

    /**
     * Puts all `items` at the end of `this` array.
     * @param items - Elements to push
     */
    public function pushAll(items:Iterable<T>) {
        for (item in items) {
            this.push(item);
        }
    }
}