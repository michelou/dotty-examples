package myexamples

object Main {

  trait Resettable {
    def reset(): this.type
  }

  trait Growable[T] {
    def add(x: T): this.type
  }

  trait Shrinkable[T] {
    def remove(x: T): this.type
  }

  trait Resizable[T] extends Growable[T] with Shrinkable[T] {
    //def add(x: T): this.type
    //def remove(x: T): this.type
  }

  final class Buffer[T] extends Resettable with Resizable[T] with Shrinkable[T] {
    private var xs: List[T] = Nil
    def reset(): this.type = {
      xs = Nil
      this
    }
    def add(x: T): this.type = {
      // :+ -> append, +: -> prepend
      xs = xs :+ x
      this
    }
    def remove(x: T): this.type =  {
      // indexOf/lastIndexOf -> remove first/last occurence
      val inx = xs.indexOf(x)
      if (inx >= 0) {
        val (xs1, xs2) = xs.splitAt(inx)
        xs = xs1 ::: xs2.tail
      }
      this
    }
    override def toString: String = {
      "Buffer" + xs.mkString("(", ",", ")")
    }
  }

  def f(x: Resettable & Resizable[Int]) = {
    x.reset().add(1).add(3).add(2).remove(3).add(3).add(4)
  }
/*
  // see https://www.typescriptlang.org/docs/handbook/advanced-types.html
  case class Person(name: String)
  trait Loggable { def log(): Unit }
  class ConsoleLogger extends Loggable {
    def log(): Unit = { println("x") }
  }
  def extend[T, U](first: T, second: U): T & U = {
    // Ok with Typescript, not possible with Dotty !?
  }
*/
  def main(args: Array[String]): Unit = {
    val buf = new Buffer[Int]
    f(buf)
    println(buf)
    
    //val jim = extend(Person("Jim"), new ConsoleLogger())
    //jim.log()
  }

}
