package myexamples

trait Wuu
case class Foo(value: Int) extends Wuu
case class Bar(value: Int) extends Wuu

object test01 {

  def hk1[S, T >: S](x: S, g: S => T): Unit = {
    type Y = [X] =>> (X, T)
    def f: Y[S] = (x, g(x))
    println("f=" + f)
  }

  def run: Unit = {
    println("------ test01 ------")
    hk1('a', s => (s.toInt + 1).toChar)
    hk1(Foo(0), _ match { case Foo(x) => Bar(x + 1) /* or Foo(x+1) */ })
    println()
  }

}

object test02 {

  def hk2[S, T <: S](x: T, g: S => T): Unit = {
    type Y = [X] =>> (X, T)
    def f: Y[S] = (x, g(x))
    println("f=" + f)
  }

  def run: Unit = {
    println("------ test02 ------")
    hk2(1.0, _ + 1)
    hk2(Bar(1), _ match { case Bar(y) => Bar(y + 1) /* but not Foo(y+1) */ })
    println()
  }

}

// see https://blog.knoldus.com/2016/09/18/functors/
object test03 {

  case class Container[A](first: A, second: A)

  trait Functor[F[_]] {
    def map[A, B](fn: A => B)(fa: F[A]): F[B]
  }

  implicit val demoFunctor: Functor[Container] = new Functor[Container] {

    def map[A, B](fn: A => B)(fa: Container[A]): Container[B] =
      Container(fn(fa.first), fn(fa.second))

  }

  def run: Unit = {
    println("------ test03 ------")
    val xs = List(Container('a', 'b'), Container('x', 'z'))

    println("xs=" + xs)
    println("xs.map(_.first.toUpper)=" + xs.map(_.first.toUpper))
    println()
  }

}

object Main {

  def main(args: Array[String]): Unit = {
    test01.run
    test02.run
    test03.run
  }

}
