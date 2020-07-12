package hello

// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class HelloJUnitTest {
  import HelloJUnitTest._

  @Test
  def test1(): Unit = {
    val stdout = captureStdout { Hello.main(Array("Bob")) }
    assertEquals("Hello message", stdout, s"Hello dotty!$eol")
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