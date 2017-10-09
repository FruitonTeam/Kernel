package fruiton;

class HashHelper {

    public static var PRIMES:Array<Int> = Macros.getPrimes();

    public static var SUM_FUNCTION = function (num: Int, total: Int) return total += num;

    /**
     * Return a prime from primes.txt file, if the index is too high it loops back
     */
    public static function getPrime(index: Int) :Int {
        return PRIMES[index % PRIMES.length];
    }

    public static function hashString(string: String): Int {
        var p0 = getPrime(6);
        var p1 = getPrime(7);
        var hash = p0;

        for (i in (0...string.length)) {
            hash = hash * p1 + string.charCodeAt(i);
        }

        return hash;
    }

    /**
     * Creates order dependent hash of iterable object
     */
    public static function hashIterable(iterable: Iterable<IHashable>, p0index: Int, p1index: Int): Int {
        var p0 = getPrime(p0index);
        var p1 = getPrime(p1index);
        var hash = p0;
        
        for (element in iterable) {
            hash = hash * p1 + element.getHashCode();
        }

        return hash;
    }
}