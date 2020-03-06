// http://junit.sourceforge.net/javadoc/org/junit/Assert.html

import org.junit.Assert._
import org.junit.Test

class EnumTreeJUnitTest {

  @Test
  def test1(): Unit = {
    import Tree._
    val data = If(IsZero(Pred(Succ(Zero))), Succ(Succ(Zero)), Pred(Pred(Zero)))
    assertEquals(Main.eval(data), Integer.valueOf(2))
  }

}
