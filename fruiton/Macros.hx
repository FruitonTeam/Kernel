package fruiton;

import haxe.macro.Expr;
import haxe.macro.Context;

class Macros {

  public static var PRIMES:Array<Int> = Macros.getPrimes();
  static var PRIME_INDEX: Int = 0;

  macro public static function getPrime(): Expr {
    var prime: Int = PRIMES[PRIME_INDEX];
    PRIME_INDEX++;
    if (PRIME_INDEX >= PRIMES.length) {
      PRIME_INDEX = 0;
    }
    return macro $v{prime};
  }

  macro public static function getPrimes(): Expr {
    var primes : Array<Int>;
    try {
      var path : String = Context.resolvePath("resources/primes.txt");
      var primeStrings: Array<String> = sys.io.File.getContent(path).split("\n");
      primes = [for (s in primeStrings) Std.parseInt(s)];
    } catch (e:Dynamic) {
      Context.error("Failed to load hash primes", Context.currentPos());
      throw(e);
    }

    var exprs = [for (value in primes) macro $v{value}];

    return macro $a{exprs};
  }
}