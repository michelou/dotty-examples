// adapted from https://blog.rockthejvm.com/eta-expansion-and-paf/
package rockthejvm

object PartiallyAppliedFunctions {

  def incrementMethod(x: Int): Int = x + 1
  PartiallyAppliedFunctions.incrementMethod(3) // 4
  this.incrementMethod(3) // 4

  val incrementFunction = (x: Int) => x + 1
  val incrementFunctionExplicit = new Function1[Int, Int] {
    override def apply(x: Int): Int = x + 1
  }
  val three: Int = incrementFunction(2)
  val threeExplicit: Int = incrementFunctionExplicit(2)

  // Eta-expansion examples
  // (see also https://dotty.epfl.ch/docs/reference/changed-features/eta-expansion-spec.html)
  //
  val incrementF = incrementMethod _  // eta-expansion
  val incrementFExplicit = (x: Int) => incrementMethod(x)  // explicit eta-expansion

  val incrementF2: Int => Int = incrementMethod // automatic Eta-expansion
  List(1, 2, 3).map(incrementMethod) // method automatically converted to function

  def multiArgAdder(x: Int)(y: Int): Int = x + y
  val add2 = multiArgAdder(2) _
  List(1, 2, 3).map(add2)

  def add(x: Int)(y: Int): Int = x + y
  val addF = add _ // (x: Int, y: Int) => x + y

  def threeArgAdder(x: Int)(y: Int)(z: Int): Int = x + y + z
  val twoArgRemaining = threeArgAdder(2) _ //
  val ten = twoArgRemaining(3)(5)
}

object Main {
  import PartiallyAppliedFunctions._

  def main(args: Array[String]): Unit = {
    println(s"incrementMethod(3)=${incrementMethod(3)}")
    println(s"three=$three")
    println(s"threeExplicit=$threeExplicit")
    println(List(1, 2, 3).map(incrementMethod))
    println(List(1, 2, 3).map(add2))
    println(s"ten=$ten")
  }

}
