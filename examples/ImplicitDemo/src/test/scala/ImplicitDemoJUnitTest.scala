// http://junit.sourceforge.net/javadoc/org/junit/Assert.html

import org.junit.Assert._
import org.junit.Test

class ImplicitDemoJUnitTest {
  import StringDelegates._

  @Test
  def test1(): Unit = {
    assertEquals("Underscorized string", "Harry".underscorize, "H_a_r_r_y_")
  }

}
