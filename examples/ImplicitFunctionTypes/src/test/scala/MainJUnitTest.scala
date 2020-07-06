// http://junit.sourceforge.net/javadoc/org/junit/Assert.html

import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {
  import ImplicitFunctionTypes._

  @Test
  def test1(): Unit = {
    val t = table {
      row {
        cell("top left")
        cell("top right")
      }
      row {
        cell("bottom left")
        cell("bottom right")
      }
    }
    assertEquals(
      "Table with 4 cells",
      t.toString,
      "Table(Row(Cell(top left), Cell(top right)), Row(Cell(bottom left), Cell(bottom right)))"
    )
  }

}
