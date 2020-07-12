// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class HelloJUnitTest {
  import HelloJUnitTest._

  @Test
  def test1(): Unit = {
    val stdout = captureStdout { Main.hello("Hello Bob!") }
    assertEquals("Hello message", stdout, s"Hello Bob!$eol")
  }

}

object HelloJUnitTest {
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