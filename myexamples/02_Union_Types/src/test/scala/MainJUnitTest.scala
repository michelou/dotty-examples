package myexamples

// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class MainJUnitTest {

  @Test
  def test2(): Unit = {
    import testPadding._

    assertEquals("padLeft", padLeft("abc", "01234"), "01234abc")
    assertEquals("padLeft", padLeft("abc", 8), "     abc")
  }

  @Test
  def test3(): Unit = {
    import testDivision._

    assertEquals("saveDivide", saveDivide(1, 2), Success(0.5))
    assertEquals("saveDivide", saveDivide(1, 0), DivisionByZero) 
  }

  @Test
  def test4(): Unit = {
    import testMessage._

    val data = handleMessage(Request(GET, new java.net.URL("https://www.google.com")))
    assertEquals("Request 1", data.toString, "https://www.google.com")

    val s = handleMessage(Response(200, "Dotty".getBytes("UTF-8"))) match {
      case a: Array[Byte] => new String(a)
      case _ => "type error"
    }
    assertEquals("Request 2", s, "Dotty")
  }

  @Test
  def test5: Unit = {
    import testJSON._

    val a = JArray(1, "abc", true)
    assertEquals(stringify(1), 1)
    assertEquals(stringify(a), """[1, "abc", true]""")
    assertEquals(
      stringify(JObject(Map("a" -> 1, "b" -> "blue", "c" -> a))),
      """{a: 1, b: "blue", c: [1, "abc", true]}""")
  }

}
