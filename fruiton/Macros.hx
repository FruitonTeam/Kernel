package fruiton;

import haxe.macro.Expr;
import haxe.macro.Context;

class Macros {

  public static macro function getPrimes(): Expr {
    var primes : Array<Int>;
    try {
      var path : String = Context.resolvePath("fruiton/kernel/primes.txt");
      var primeStrings: Array<String> = sys.io.File.getContent(path).split("\n");
      primes = [for (s in primeStrings) Std.parseInt(s)];
    }
    catch (e:Dynamic) {
      Context.error("Failed to load hash primes", Context.currentPos());
      throw(e);
    }
    
    var exprs = [for (value in primes) macro $v{value}];
    
    return macro $a{exprs};
  }
}