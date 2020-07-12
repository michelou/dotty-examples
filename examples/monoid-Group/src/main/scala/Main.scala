trait SemiGroup[T] {
  extension (x: T) def combine(y: T): T
}

trait Monoid[T] extends SemiGroup[T] {
  def unit: T
} 

trait Group[T] extends Monoid[T] {
  extension (x: T) def inverse: T
}

trait GroupMod[N <: Int] extends Group[Int] {
  def unit: N
  extension (x: Int) def combine(y: Int) = (x + y) % unit
  extension (x: Int) def inverse = (-x) % unit
}  

given [N <: Int : ValueOf] as GroupMod[N] {
  val unit: N = valueOf[N]
}

def foo(x: Int, y: Int)(using GroupMod[7]): Int = x.combine(y)

@main def Test = println(foo(10, 3))
