package myexamples

import org.junit.Assert._
import org.junit.Test

class HelloWorldJUnitTest {
  import HelloWorldJUnitTest._

  @Test
  def test1(): Unit = {
    val stdout = captureStdout { HelloWorld.main(Array("Bob")) }
    assertEquals("Hello message", stdout, s"Hello world!$eol")
  }

}

object HelloWorldJUnitTest {
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
