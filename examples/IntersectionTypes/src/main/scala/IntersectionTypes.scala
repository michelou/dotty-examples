/**
 * Intersection Types:
 * http://dotty.epfl.ch/docs/reference/intersection-types.html
 */
object IntersectionTypes {

  trait Resettable {
    def reset(): this.type
  }

  trait Growable[T] {
    def add(x: T): this.type
  }

  final class Buffer[T] extends Resettable with Growable[T] {
    private var xs: List[T] = Nil

    def reset(): this.type = {
      xs = Nil
      this
    }

    def add(x: T): this.type = {
      xs = xs :+ x
      this
    }

    override def toString: String = {
      "Buffer" + xs.mkString("(", ",", ")")
    }

  }

  def test: Unit = {

    def f(x: Resettable & Growable[String]) = {
      x.reset()
      x.add("first")
    }

    val buf = new Buffer[String]
    f(buf)
    println(buf)

  }

}
