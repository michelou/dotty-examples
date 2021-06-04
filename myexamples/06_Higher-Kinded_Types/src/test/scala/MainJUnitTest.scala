package myexamples

// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {
  import MainJUnitTest._

  @Test
  def test1(): Unit = {
    import test01._

    val stdout = captureStdout { hk1('a', s => (s.toInt + 1).toChar) }
    assertEquals("Hello message", stdout, s"f=(a,b)$eol")
  }

  @Test
  def test2(): Unit = {
    import test02._

    val stdout = captureStdout { hk2(1.0, _ + 1) }
    assertEquals("Hello message", stdout, s"f=(1.0,2.0)$eol")
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
