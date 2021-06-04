package myexamples

// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert.assertEquals
import org.junit.Test

class MainTest {
  import MainTest._

  @Test
  def test01(): Unit = {
    val stdout = captureStdout { Main.test01 }
    assertEquals("test01", stdout, s": d : o : t : t : y ${eol}0: d 1: o 2: t 3: t 4: y $eol")
  }

  @Test
  def test02(): Unit = {}

}

object MainTest {
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