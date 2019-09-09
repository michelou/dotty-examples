// http://junit.sourceforge.net/javadoc/org/junit/Assert.html

import org.junit.Assert._
import org.junit.Test

class ColorTest {

  @Test
  def test1(): Unit = {
    assertEquals("Enumeration contains 3 colors", Color.values.size, 3)
  }
}