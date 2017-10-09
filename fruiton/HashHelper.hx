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
        return Lambda.fold(
            [for (i in (0...string.length)) string.charCodeAt(i) * getPrime(3)],
            SUM_FUNCTION,
            0
        ) + getPrime(8);
    }

    /**
     * Creates order dependent hash of iterable object
     */
    public static function hashIterable(iterable: Iterable<IHashable>, indexStart: Int, indexDiff: Int): Int {
        var result: Int = 0;
        var primeIndex = indexStart;
        
        for (element in iterable) {
            result += element.getHashCode() * getPrime(primeIndex);
            primeIndex += indexDiff;
        }

        return result;
    }
}