import org.junit.Assert.{assertFalse, assertTrue}
import org.junit.Test

class SudokuJUnitTest:
  import Sudoku.*

  @Test
  def test1(): Unit =
    assertTrue("test1", validate(problem, 5, 2, 4)) // true
    assertTrue("test1_2", validate2(problem, 5, 2, 4)) // true

  @Test
  def test2(): Unit =
    assertFalse("test2", validate(problem, 5, 2, 5)) // false (column property)
    assertFalse("test2_2", validate2(problem, 5, 2, 5)) // false (column property)

  @Test
  def test3(): Unit =
    assertFalse("test3", validate(problem, 5, 2, 7)) // false (box property)
    assertFalse("test3_2", validate2(problem, 5, 2, 7)) // false (box property)