// see https://dotty.epfl.ch/docs/reference/contextual/extension-methods.html

// Extension methods allow one to add methods to a type after the type is defined.
object ex1 {

  case class Circle(x: Double, y: Double, radius: Double)

  extension (c: Circle)
    def circumference: Double = c.radius * math.Pi * 2

  def run: Unit =
    println("------------ ex1 -------------")
    val circle = Circle(0, 0, 1)
    println(s"Circumference=${circle.circumference}")

}

// The extension method syntax can also be used to define operators.
object ex2 {

  case class Elem(x: Int)
  type Number = Int

  extension (x: String)
    def < (y: String): Boolean =
      println("*** calling extension method 'extension_<'")
      x.compareTo(y) < 0

  extension (x: Elem)
    def !: (xs: Seq[Elem]): Seq[Elem] =
      println("*** calling extension method 'extension_!:'")
      x +: xs

  extension (x: Number)
    infix def min (y: Number): Number =
      println("*** calling extension method 'extension_min'")
      Math.min(x, y)

  def run: Unit =
    val x = 0
    println("------------ ex2 -------------")
    println("ab" < "c")
    println(1 +: List(2, 3))
    println(s"x min 3=${x min 3}")

}

// Generic types can also be extended by adding type parameters to an extension
object ex3 {

  extension [T](xs: List[T])
    def second = xs.tail.head

  extension [T: Numeric](x: T)
    def + (y: T): T = summon[Numeric[T]].plus(x, y)

  def run: Unit =
    val xs = List(1, 2, 3)
    println("------------ ex3 -------------")
    println(s"list xs=${xs}")
    println(s"second element=${xs.second}")

}

// Collective extensions share the same left-hand parameter type.
object ex4 {

  extension (ss: Seq[String])

    def longestStrings: Seq[String] =
      val maxLength = ss.map(_.length).max
      ss.filter(_.length == maxLength)

    def longestString: String = longestStrings.head

  def run: Unit =
    val ss = List("class", "language", "type")
    println("------------ ex4 -------------")
    println(s"list ss=${ss}")
    println(s"longest string=${ss.longestString}")

}

@main def Main: Unit =
  ex1.run
  ex2.run
  ex3.run
  ex4.run
