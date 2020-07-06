// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {
  import scala.language.implicitConversions
  import UnionTypes._

  @Test
  def test1: Unit = {
    val password = Password(123)
    val name = UserName("Eve")
    val either: Password | UserName = if (true) name else password
    assertEquals("", either.toString, "UserName(Eve)")
  }

}
