trait SemiGroup[T] {
  implicit class SemigroupExtension(x: T) {
    def combine(y: T): T
  }
}

trait Monoid[T] extends SemiGroup[T] {
  def unit: T
} 

trait Group[T] extends Monoid[T] {
  implicit class GroupExtension(x: T) {
    def inverse: T
  }
}

trait GroupMod[N <: Int] extends Group[Int] {
  def unit: N
  implicit class E(x: Int) {
    def combine(y: Int) = (x + y) % unit
    def inverse = (-x) % unit
  }
}

object Test {
  import scala.language.implicitConversions
/*
  implicit def x[N <: Int : ValueOf](n: N) = new GroupMod[N] {
    val unit: N = valueOf[N]
  }
*/
  implicit val g = new GroupMod[Int] {
    val unit: Int = 7
    implicit class X(x: Int) {
      def combine(y: Int) = (x + y) % unit
    }
  }

  def foo(x: Int, y: Int)(implicit g: GroupMod[Int]): Int = {
    import g._
    x.combine(y)
  }

  def main(args: Array[String]): Unit = 
    println(foo(10, 3))

}
