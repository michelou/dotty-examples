// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {
  import Main._

  @Test
  def test1(): Unit = {
    val personInterpolator = person"Bob,$age"
    assertEquals("", personInterpolator.toString, "Person(Bob,55)")
  }

}
