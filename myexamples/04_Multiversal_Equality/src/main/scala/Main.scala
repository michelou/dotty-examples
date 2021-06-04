// see https://dotty.epfl.ch/docs/reference/contextual/multiversal-equality.html

package myexamples

object Main {

  private def test1: Unit = {
    //import scala.language.strictEquality

    given eqStringChar: CanEqual[String, Char] = CanEqual.derived
    given eqCharString: CanEqual[Char, String] = CanEqual.derived
    println("2" == '2')
    println('2' == "2")
  }

  private def test2: Unit = {
    //import scala.language.strictEquality

    given eqStringChar: CanEqual[Char | String, Char | String] = CanEqual.derived
    println("2" == '2')
    println('2' == "2")
  }

  def testCharInt: Unit = { // Char <: Number
    println('2' == 2)
    println(2 == '2')
    println('2' == 50) // ASCII code of '2' is 50
    println(50 == '2')
  }

  def testBooleanChar: Unit = {
    type T = Boolean | Char
    var b: T = true
    println(true == b)
    val ch: T = 'b'
    println(true == ch)
  }
  
  private def runExample(name: String)(f: => Unit) = {
    println(Console.MAGENTA + s"$name example:" + Console.RESET)
    f
    println()
  }

  def main(args: Array[String]): Unit = {
    z6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ("test1")(test1)
    runExample("test2")(test2)
    runExample("testCharInt")(testCharInt)
    runExample("testBooleanChar")(testBooleanChar)
  }

}
