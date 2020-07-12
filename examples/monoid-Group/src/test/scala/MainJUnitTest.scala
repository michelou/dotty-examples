// http://junit.sourceforge.net/javadoc/org/junit/Assert.html

import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {

  @Test
  def test1(): Unit = {
    assertEquals("foo", foo(10, 3), 6)
  }
}
