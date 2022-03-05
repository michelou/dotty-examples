// see from https://blog.rockthejvm.com/type-level-programming-part-2/
package rockthejvm

object TypeLevelProgramming:
  import scala.reflect.runtime.universe._

  def show[T](value: T)(implicit tag: TypeTag[T]) =
    tag.toString.replace("rockthejvm.TypeLevelProgramming.", "")

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

  trait +[A <: Nat, B <: Nat] { type Result <: Nat }
  object + {
    type Plus[A <: Nat, B <: Nat, S <: Nat] = +[A, B] { type Result = S }
    implicit val zero: Plus[_0, _0, _0] = new +[_0, _0] { type Result = _0 }
    implicit def basicRight[B <: Nat](implicit lt: _0 < B): Plus[_0, B, B] =
      new +[_0, B] { type Result = B }
    implicit def basicLeft[B <: Nat](implicit lt: _0 < B): Plus[B, _0, B] =
      new +[B, _0] { type Result = B }
    implicit def inductive[A <: Nat, B <: Nat, S <: Nat]
        (implicit plus: Plus[A, B, S]): Plus[Succ[A], Succ[B], Succ[Succ[S]]] =
      new +[Succ[A], Succ[B]] { type Result = Succ[Succ[S]] }
    def apply[A <: Nat, B <: Nat]
        (implicit plus: +[A, B]): Plus[A, B, plus.Result] = plus
  }

  val zeroSum: +[_0, _0] = +.apply[_0, _0]
  val anotherSum: +[_0, _2] = +.apply[_0, _2]
  // val four: +[_2, _3] = +.apply[_2, _3]

  def main(args: Array[String]): Unit =
    println(show(+.apply[_0, _2]))
