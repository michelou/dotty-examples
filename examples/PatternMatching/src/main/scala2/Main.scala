// Scala 2 version adapted from http://dotty.epfl.ch/docs/reference/changed-features/pattern-matching.html

object Main {

  // Boolean Match

  object Even {
    def unapply(s: String): Boolean = s.size % 2 == 0
  }

  def booleanMatch: Unit = {
    "even" match {
      case s @ Even() => println(s"$s has an even number of characters")
      case s          => println(s"$s has an odd number of characters")
    }
  }

  // Product Match

  class FirstChars(s: String) extends Product {
    def _1 = s.charAt(0)
    def _2 = s.charAt(1)

    // Not used by pattern matching: Product is only used as a marker trait.
    def canEqual(that: Any): Boolean = ???
    def productArity: Int = ???
    def productElement(n: Int): Any = ???
    // scala 2 specific
    def isEmpty: Boolean = s == null || s.length == 0
    def get: String = s
  }

  object FirstChars {
    def unapply(s: String): FirstChars = new FirstChars(s)
  }

  def productMatch: Unit = {
    "Hi!" match {
      case fc @ FirstChars(_) =>
        println(s"First: $fc._1; Second: $fc._2")
    }
  }

  // Single Match

  class Nat(val x: Int) {
    def get: Int = x
    def isEmpty = x < 0
  }

  object Nat {
    def unapply(x: Int): Nat = new Nat(x)
  }

  def singleMatch: Unit = {
    5 match {
      case Nat(n) => println(s"$n is a natural number")
      case _      => ()
    }
  }

  // Named-based Match

  object ProdEmpty {
    def _1: Int = ???
    def _2: String = ???
    def isEmpty = true
    def unapply(s: String): this.type = this
    def get = this
  }

  def nameBasedMatch: Unit = {
    "" match {
      case ProdEmpty(_, _) => ???
      case _ => ()
    }
  }

  // Sequence Match

  object CharList {
    def unapplySeq(s: String): Option[Seq[Char]] = Some(s.toList)
  }

  def sequenceMatch: Unit = {
    "example" match {
      case CharList(c1, c2, c3, c4, _, _, _) =>
        println(s"$c1,$c2,$c3,$c4")
      case _ =>
        println("Expected *exactly* 7 characters!")
    }
  }

  def main(args: Array[String]): Unit = {
    booleanMatch
    productMatch
    singleMatch
    nameBasedMatch
    sequenceMatch
  }

}
