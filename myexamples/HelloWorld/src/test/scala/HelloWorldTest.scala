package myexamples

// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class HelloWorldTest {
  import HelloWorldTest._

  @Test
  def test1(): Unit = {
    val stdout = captureStdout { HelloWorld.main(Array("Bob")) }
    assertEquals("Hello message", stdout, s"Hello world!$eol")
  }

}

object HelloWorldTest {
  import java.io._

  val eol = System.getProperty("line.separator")

  private def captureStdout(block: => Unit): String = {
    val baos = new ByteArrayOutputStream()
    val ps = new PrintStream(baos)
    System.setOut(ps)
    block
    val stdout = baos.toString()
    ps.close()
    System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)))
    stdout
  }

}