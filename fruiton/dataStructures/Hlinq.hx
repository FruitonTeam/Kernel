package fruiton.dataStructures;

class Hlinq {

    /**
     * Finds and returns first item of given type, null of non found
     * @param items - List to search in
     * @param type - Type to search in `items`
     * @return First item of `type` in `items`, null otherwise
     */
    public static function firstOfTypeOrNull<T, U>(items:Iterable<T>, type:Class<U>):U {
        for (item in items) {
            if (Std.is(item, type)) {
                return cast item;
            }
        }
        return null;
    }

    /**
     * Finds and returns single item of given type, null if none or more than one found
     * @param items - List to search in
     * @param type - Type to search in `items`
     * @return Single item of `type` in `items`, null otherwise
     */
    public static function singleOfTypeOrNull<T, U>(items:Iterable<T>, type:Class<U>):U {
        var result:U = null;

        for (item in items) {
            if (Std.is(item, type)) {
                if (result != null) {
                    return null;
                }
                result = cast item;
            }
        }

        return result;
    }
}
