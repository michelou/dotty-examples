// see https://dotty.epfl.ch/docs/reference/contextual/extension-methods.html

import org.junit.Test

class MainJUnitTest {

  @Test
  def test1(): Unit = {
    val circle = Circle(0, 0, 1)
    assertEquals("Circumference of a circle", circle.circumference, extension_circumference(circle))
  }

  @Test
  def test1(): Unit = {
    assertEquals("String comparison", "ab" < "c", extension_<("ab", "c"))
  }

}
