package myexamples

object Main {

  trait Wuu
  case class Foo(value: Int) extends Wuu
  case class Bar(value: Int) extends Wuu

  def test01: Unit = {
    def hk1[S, T >: S](x: S, g: S => T): Unit = {
      type Y = [X] => (X, T)
      def f: Y[S] = (x, g(x))
      println("f="+f)
    }
    
    hk1('a', s => (s.toInt+1).toChar)
    hk1(Foo(0), _ match { case Foo(x) => Bar(x+1) /* or Foo(x+1) */ })
  }

  def test02: Unit = {
    def hk2[S, T <: S](x: T, g: S => T): Unit = {
      type Y = [X] => (X, T)
      def f: Y[S] = (x, g(x))
      println("f="+f)
    }

    hk2(1.0, _+1)
    hk2(Bar(1), _ match { case Bar(y) => Bar(y+1) /* but not Foo(y+1) */ })
  }

  // see https://blog.knoldus.com/2016/09/18/functors/
  def test03: Unit = {
    case class Container[A](first: A, second: A)

    trait Functor[F[_]] {
      def map[A, B](fn: A => B)(fa: F[A]): F[B]
    }

    implicit val demoFunctor: Functor[Container] = new Functor[Container] {
      def map[A, B](fn: A => B)(fa: Container[A]): Container[B] =
        Container(fn(fa.first), fn(fa.second))
    }
    val xs = List(Container('a', 'b'), Container('x', 'z'))

    println("xs="+xs)
    println("xs.map(_.first.toUpper)="+xs.map(_.first.toUpper))
  }

  private def runExample(name: String)(f: => Unit) = {
    println(Console.MAGENTA + s"$name example:" + Console.RESET)
    f
    println()
  }

  def main(args: Array[String]): Unit = {
    runExample("test01")(test01)
    runExample("test02")(test02)
    runExample("test03")(test03)
  }
}
