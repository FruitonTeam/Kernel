package fruiton.dataStructures;

class Hlinq {

    public static function firstOfTypeOrNull<T, U>(items:Iterable<T>, type:Class<U>):U {
        for (item in items) {
            if (Std.is(item, type)) {
                return cast item;
            }
        }
        return null;
    }

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
