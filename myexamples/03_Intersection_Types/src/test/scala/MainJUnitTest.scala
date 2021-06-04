package myexamples

// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {

  @Test
  def test1(): Unit = {
    val buf = new Main.Buffer[Int]
    val res = Main.f(buf)
    assertEquals("call to f", res.toString, "Buffer(1,2,3,4)") 
  }

}
