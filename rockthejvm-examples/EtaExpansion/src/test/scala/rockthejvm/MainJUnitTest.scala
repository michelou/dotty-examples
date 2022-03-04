package rockthejvm

import org.junit.Assert._
import org.junit.Test
import scala.language.implicitConversions

class MainJUnitTest {
  import PartiallyAppliedFunctions._

  @Test
  def test1(): Unit = {
    assertEquals("incrementMethod(3) == 4", incrementMethod(3), 4)
    assertEquals("three == 3", three, 3)
  }

  @Test
  def test2(): Unit = {
    assertEquals("map(incrementMethod)", List(1, 2, 3).map(incrementMethod), List(2, 3, 4))
  }

  @Test
  def test3(): Unit = {
    assertEquals("map(add2)", List(1, 2, 3).map(add2), List(3, 4, 5))
  }

}
