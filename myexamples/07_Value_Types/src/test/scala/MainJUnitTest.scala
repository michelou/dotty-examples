package myexamples

// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

import scala.language.implicitConversions

class MainJUnitTest {
  import Main.Meter

  @Test
  def test1(): Unit = {
    val m: Meter = new Meter(3)
    assertEquals("test1", m.plus(new Meter(2)).underlying, 5)
  }

}
