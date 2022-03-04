package rockthejvm

import org.junit.Assert.assertEquals
import org.junit.Test

class MainJUnitTest:

  @Test
  def test1(): Unit =
    val tree = Branch(Leaf(1), Leaf(2))
    assertEquals("tree.sum", tree.sum, 3)
    assertEquals("tree.sum1", tree.sum1, 3)
