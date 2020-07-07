// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class IntersectionTypesJUnitTest {
  import IntersectionTypes._

  @Test
  def test1: Unit = {
    def euclideanDistance(p1: X & Y, p2: X & Y) = {
      Math.sqrt(Math.pow(p2.y - p1.y, 2) + Math.pow(p2.x - p1.x, 2))
    }

    val p1: P = Point(3, 4)
    val p2: PP = Point(6, 8)
    assertEquals("Euclide distance", euclideanDistance(p1, p2), 5.0f, /*delta value*/0.0f)
  }

}
