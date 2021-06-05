// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert.assertEquals
import org.junit.Test

class JUnitTest {

  @Test
  def test1(): Unit = {
    val sunday1 = Day.SUNDAY.ordinal
    val sunday2 = ScalaDay.SUNDAY.ordinal
    assertEquals(
      "Java and Scala sundays have same ordinal value",
      sunday1.toLong,
      sunday2.toLong
    )
  }

}
