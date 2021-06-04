package myexamples

// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert.assertEquals
import org.junit.Test

class MainJUnitTest {
  import Main._

  @Test
  def test1(): Unit = {
    val m = HMap.empty.add(width)(120)
    assertEquals("Map contains 1 element", m.toString, "HashMap(width -> 120)")
  }

}
