package myexamples

// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {
  import Main._

  @Test
  def test1(): Unit = {
    val a = new Bird
    val b = a.legsCount
    val s = (a, b) match {
      case (a @ Biped(), _) => s"A $a has two legs"
      case (a, _)           => s"A $a doesn't have two legs"
    }
    assertEquals("Boolean pattern", s, "A bird has two legs")
  }

}
