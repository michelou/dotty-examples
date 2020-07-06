// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class IntersectionTypesJUnitTest {
  import IntersectionTypes._

  @Test
  def test1: Unit = {
    def f(x: Resettable & Growable[String]) = {
      x.reset()
      x.add("first")
    }
    val buf = new Buffer[String]
    assertEquals("test1", f(buf).toString, "Buffer(first)")
  }

}
