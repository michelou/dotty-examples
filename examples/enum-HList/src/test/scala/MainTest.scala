// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class MainTest {

  @Test
  def test1(): Unit = {
    import HLst._
    val hl = HCons(1, HCons("A", HNil))
    assertEquals("List h1 has length 2", Main.length(hl), 2)
  }
}

/*
// JUnit 5
//
// https://junit.org/junit5/docs/current/user-guide/#writing-tests-assertions
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

class MainTest {

  @Test
  @DisplayName("hl = HCons(1, HCons(\"A\", HNil)")
  def test1(): Unit = {
    import HLst._
    val hl = HCons(1, HCons("A", HNil))
    Assertions.assertEquals(Main.length(hl), 2)
  }
}
*/
