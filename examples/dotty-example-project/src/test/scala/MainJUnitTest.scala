import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {
  import MainJUnitTest._

  @Test
  def traitParams(): Unit = {
    val stdout = captureStdout { TraitParams.test }
    assertEquals("TraitParams.test", stdout, s"Hello Dotty!$eol")
  }

  @Test
  def enumTypes: Unit = {
    val stdout = captureStdout { EnumTypes.test }
    assertEquals("EnumTypes.test", stdout, """Empty
    |Cons(1,Cons(2,Cons(3,Empty)))
    |
    |Your weight on MERCURY is 30.22060921607482
    |Your weight on VENUS is 72.39992798728365
    |Your weight on EARTH is 80.0
    |Your weight on MARS is 30.29897472297031
    |Your weight on JUPITER is 202.44460203965926
    |Your weight on SATURN is 85.28124310492532
    |Your weight on URANUS is 72.41017595115402
    |Your weight on NEPTUNE is 91.06624579757263
    |""".stripMargin)
  }

}

object MainJUnitTest {
  import java.io._

  private val eol = System.getProperty("line.separator")

  private val baos = new ByteArrayOutputStream()
  System.setOut(new PrintStream(baos))

  private def captureStdout(block: => Unit): String = {
    block
    val stdout = baos.toString()
    baos.reset()
    stdout
  }

}
