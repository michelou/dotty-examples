// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {
  import UnionTypes._

  @Test
  def test1: Unit = {
    val divisionResultSuccess: DivisionResult = safeDivide(4, 2)
    assertEquals("Division", either(divisionResultSuccess), Right(2))
  }

}
