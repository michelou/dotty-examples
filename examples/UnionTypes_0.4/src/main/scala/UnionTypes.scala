/**
 * Union Types: http://dotty.epfl.ch/docs/reference/union-types.html
 */
object UnionTypes {

  sealed trait Division
  final case class DivisionByZero(msg: String) extends Division
  final case class Success(double: Double) extends Division

  // You can create type aliases for your union types (sum types).
  type DivisionResult = DivisionByZero | Success

  sealed trait List[+A]
  final case class Empty() extends List[Nothing]
  final case class Cons[+A](h: A, t: List[A]) extends List[A]

  def safeDivide(a: Double, b: Double): DivisionResult = {
    if (b == 0) DivisionByZero("DivisionByZeroException") else Success(a / b)
  }

  def either(division: Division) = division match {
    case DivisionByZero(m) => Left(m)
    case Success(d) => Right(d)
  }

  def test: Unit = {

    val divisionResultSuccess: DivisionResult = safeDivide(4, 2)

    // commutative
    val divisionResultFailure: Success | DivisionByZero = safeDivide(4, 0)

    // calling `either` function with union typed value.
    println(either(divisionResultSuccess))

    // calling `either` function with union typed value.
    println(either(divisionResultFailure))

    val list: Cons[Int] | Empty = Cons(1, Cons(2, Cons(3, Empty())))
    val emptyList: Empty | Cons[Any] = Empty()
    println(list)
    println(emptyList)

  }

}
