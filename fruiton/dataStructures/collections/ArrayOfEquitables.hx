package fruiton.dataStructures.collections;

import fruiton.IEquitable;

@:forward
abstract ArrayOfEquitables<T:IEquitable<T>>(Array<T>)
from Array<T>
to Array<T> {

    public static var NONE:Int = -1;

    /**
     * Find item in array based on value equality.
     * @param item to find
     * @return Index of item if found, ArrayOfEquitables.NONE otherwise.
     */
    public function findIndex(item:T):Int {
        if (this == null || item == null) {
            return NONE;
        }

        var idx:Int = 0;
        for(arrayItem in this) {
            if (item.equalsTo(arrayItem)) {
                return idx;
            }
            ++idx;
        }

        return NONE;
    }

    public function contains(item:T):Bool {
        return findIndex(item) != NONE;
    }

    /**
     * Removes duplicate items from array.
     * Only works on sorted arrays - duplicates need to be next to each other.
     */
    public function unique() {
        // Empty or 1 element arrays have no duplicates
        if (this.length < 2) {
            return;
        }
        var i:Int = this.length;
        while (i-- > 1) {
            if (this[i].equalsTo(this[i - 1])) {
                this.splice(i, 1);
            }
        }
    }
}