// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {
  import MainJUnitTest._

  @Test
  def functorsTest: Unit = {
    val stdout = captureStdout { Functors.test }
    assertEquals("Functors", stdout, """functorForOption: Some(1)
        |Some(-1)
        |functorForList: List(Some(1), None, Some(2))
        |functorForList: List(None, Some(2))
        |functorForList: List(Some(2))
        |functorForList: List()
        |List(1, 0, 2)
        |""".stripMargin
    )
  }

  @Test
  def typeAliasesTest: Unit = {
    val stdout = captureStdout { TypeAliases.test }
    assertEquals("TypeAliases", stdout, """11
        |11
        |11
        |""".stripMargin
    )
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