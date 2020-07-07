// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {
  import EnumTypes._

  @Test
  def test1(): Unit = {
    val planet = Planet.VENUS
    assertEquals("Planet Venus", planet.surfaceGravity, 1.1)
  }

}
