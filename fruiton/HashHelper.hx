package fruiton;

class HashHelper {

    public static var PRIMES:Array<Int> = Macros.getPrimes();

    public static var SUM_FUNCTION = function (num: Int, total: Int) return total += num;

    public static function getPrime(i: Int) :Int {
        return PRIMES[i % PRIMES.length];
    }

    public static function hashString(string: String): Int {
        return Lambda.fold(
            [for (i in (0...string.length)) string.charCodeAt(i) * getPrime(3)],
            SUM_FUNCTION,
            0
        ) + getPrime(8);
    }

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