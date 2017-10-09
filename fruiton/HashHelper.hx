package fruiton;

class HashHelper {

    public static var PRIME_0: Int = 1453335277;
    public static var PRIME_1: Int = 402682283;

    public static function hashString(string: String): Int {
        var hash = PRIME_0;

        for (i in (0...string.length)) {
            hash = hash * PRIME_1 + string.charCodeAt(i);
        }

        return hash;
    }

    /**
     * Creates order dependent hash of iterable object
     */
    public static function hashIterable(iterable: Iterable<IHashable>): Int {
        var hash = PRIME_0;

        for (element in iterable) {
            hash = hash * PRIME_1 + element.getHashCode();
        }
        return hash;
    }
}