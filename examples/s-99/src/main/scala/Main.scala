object Main {

  def main(args: Array[String]): Unit = {
    val xs = List(1, 2, 3, 4, 5)
    val ys = List(1, 2, 3, 4, 5, 8)
    val zs = List(1, 2, 3, 4, 3, 2, 1)

    val xss = List(List(1, 1), 2, List(3, List(5, 8)))

    println("Given:")
    println(s"   xs = ${xs}")
    println(s"   ys = ${ys}")
    println(s"   zs = ${zs}")
    println()
    println(s"P01.lastBuiltin(${xs}) = ${P01.lastBuiltin(xs)}")
    println()
    println(s"P02.penultimateBuiltin(${ys}) = ${P02.penultimateBuiltin(ys)}")
    println(s"P02.lastNthBuiltin(2, ${ys})  = ${P02.lastNthBuiltin(2, ys)}")
    println()
    println(s"P03.nthBuiltin(2, ${ys})   = ${P03.nthBuiltin(2, ys)}")
    println(s"P03.nthRecursive(2, ${ys}) = ${P03.nthRecursive(2, ys)}")
    println()
    println(s"P04.lengthBuiltin(${xs})       = ${P04.lengthBuiltin(xs)}")
    println(s"P04.lengthRecursive(${xs})     = ${P04.lengthRecursive(xs)}")
    println(s"P04.lengthTailRecursive(${xs}) = ${P04.lengthTailRecursive(xs)}")
    println(s"P04.lengthFunctional(${xs})    = ${P04.lengthFunctional(xs)}")
    println()
    println(s"P05.reverseBuiltin(${xs})       = ${P05.reverseBuiltin(xs)}")
    println(s"P05.reverseRecursive(${xs})     = ${P05.reverseRecursive(xs)}")
    println(s"P05.reverseTailRecursive(${xs}) = ${P05.reverseTailRecursive(xs)}")
    println(s"P05.reverseFunctional(${xs})    = ${P05.reverseFunctional(xs)}")
    println()
    println(s"P06.isPalindrome(${ys})) = ${P06.isPalindrome(ys)}")
    println(s"P06.isPalindrome(${zs})) = ${P06.isPalindrome(zs)}")
    println()
    println("Given:")
    println(s"   xss = ${xss}")
    println()
    println(s"P07.flatten(${xss}) = ${P07.flatten(xss)}")
    println()
  }

}
