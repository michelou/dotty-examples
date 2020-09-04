// http://junit.sourceforge.net/javadoc/org/junit/Assert.html

import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {

  @Test
  def test1(): Unit = {
    import ex1._

    val circle = Circle(0, 0, 1)
    assertEquals("Circle circumference", circle.circumference, 6.28, /*delta*/0.01)
  }

  @Test
  def test2(): Unit = {
    import ex2._
 
    val x = 10
    assertEquals("String comparison", "ab" < "c", true)
    assertEquals("List prepend", 1 +: List(2, 3), List(1, 2, 3))
    assertEquals("Infix min", x min 3, 3)
  }
}
