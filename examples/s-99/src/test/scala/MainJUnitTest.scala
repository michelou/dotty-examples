// http://junit.sourceforge.net/javadoc/org/junit/Assert.html

import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {
  import scala.language.implicitConversions

  ////////////////////////////////////////////////////////////////////////////
  // lists

  @Test
  def p01_test(): Unit = {
    val xs = List(1, 2, 3, 4, 5)
    assertEquals("Last element of xs", P01.lastBuiltin(xs), 5)
    assertEquals("lastBuiltin/lastRecursive", P01.lastBuiltin(xs), P01.lastRecursive(xs))
  }

  @Test
  def p01_test2(): Unit = {
    val exception = assertThrows(classOf[NoSuchElementException], () => P01.lastBuiltin(Nil))
    val expectedMessage = "empty list"
    val actualMessage = exception.getMessage()
    assertTrue(actualMessage.contains(expectedMessage))
    
  }

  @Test
  def p02_test(): Unit = {
    val ys = List(1, 2, 3, 4, 5, 8)
    assertEquals("Second-last element of ys", P02.penultimateBuiltin(ys), 5)
    assertEquals("penultimateBuiltin/penultimateRecursive", P02.penultimateBuiltin(ys), P02.penultimateRecursive(ys))
  }

  @Test
  def p02_test2(): Unit = {
    val ys = List(1, 2, 3, 4, 5, 8)
    assertEquals("Last n elements of ys", P02.lastNthBuiltin(2, ys), 5)
    assertEquals("lastNthBuiltin/lastNthRecursive/", P02.lastNthBuiltin(2, ys), P02.lastNthRecursive(2, ys))
  }

}
