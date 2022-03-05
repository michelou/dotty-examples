// see https://blog.rockthejvm.com/type-level-programming-part-1/
package rockthejvm

object TypeLevelProgramming:
  import scala.reflect.runtime.universe._

  def show[T](value: T)(implicit tag: TypeTag[T]) =
    tag.toString().replace("rockthejvm.TypeLevelProgramming.", "")

  trait Nat
  class _0 extends Nat
  class Succ[A <: Nat] extends Nat

  type _1 = Succ[_0]
  type _2 = Succ[_1] // = Succ[Succ[_0]]
  type _3 = Succ[_2] // = Succ[Succ[Succ[_0]]]
  type _4 = Succ[_3]
  type _5 = Succ[_4]

  trait <[A <: Nat, B <: Nat]
  object < {
    def apply[A <: Nat, B <: Nat](implicit lt: <[A, B]): <[A, B] = lt
    implicit def ltBasic[B <: Nat]: <[_0, Succ[B]] = new <[_0, Succ[B]] {}
    implicit def inductive[A <: Nat, B <: Nat]
        (implicit lt: <[A, B]): <[Succ[A], Succ[B]] =
      new <[Succ[A], Succ[B]] {}
  }

  sealed trait <=[A <: Nat, B <: Nat]
  object <= {
    def apply[A <: Nat, B <: Nat](implicit lte: <=[A, B]): <=[A, B] = lte
    implicit def lteBasic[B <: Nat]: <=[_0, B] = new <=[_0, B] {}
    implicit def inductive[A <: Nat, B <: Nat]
        (implicit lt: <=[A, B]): <=[Succ[A], Succ[B]] =
      new <=[Succ[A], Succ[B]] {}
  }

  val validComparison: _2 < _3 = <.apply[_2, _3]
  //val invalidComparison: _3 < _2 = <.apply[_3, _2]

  def main(args: Array[String]): Unit =
    println(show(<.apply[_2, _3]))
