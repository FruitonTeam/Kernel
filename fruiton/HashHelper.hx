package fruiton;

class HashHelper {

    public static var PRIMES:Array<Int> = Macros.getPrimes();

    /**
     * Return a prime from primes.txt file, if the index is too high it loops back
     */
    public static function getPrime(index: Int) :Int {
        return PRIMES[index % PRIMES.length];
    }

    public static function hashString(string: String): Int {
        var p0 = Macros.getPrime();
        var p1 = Macros.getPrime();
        var hash = p0;

        for (i in (0...string.length)) {
            hash = hash * p1 + string.charCodeAt(i);
        }

        return hash;
    }

    /**
     * Creates order dependent hash of iterable object
     */
    public static function hashIterable(iterable: Iterable<IHashable>, p0: Int, p1: Int): Int {
        var hash = p0;

        for (element in iterable) {
            hash = hash * p1 + element.getHashCode();
        }

        return hash;
    }
}