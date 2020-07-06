// http://junit.sourceforge.net/javadoc/org/junit/Assert.html

import org.hamcrest.CoreMatchers._
import org.hamcrest.MatcherAssert._
import org.junit.Test

class MainJUnitTest {
  import MainJUnitTest._

  @Test
  def test1(): Unit = {
    val stdout = captureStdout { println(new Main.C) }
    assertThat("classOf[C]", stdout, containsString(s"[class Main$$C] How are you, Bob$eol"))
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