// http://junit.sourceforge.net/javadoc/org/junit/Assert.html

import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {
  import Macros._

  @Test
  def test1(): Unit = {
    assertEquals("natConst", natConst(4), Integer.valueOf(4))
  }

}
