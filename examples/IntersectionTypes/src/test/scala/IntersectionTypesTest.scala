import org.junit.Assert._
import org.junit.Test

class IntersectionTypesTest {
  import IntersectionTypes._

  @Test
  def test1: Unit = {

    def f(x: Resettable & Growable[String]) = {
      x.reset()
      x.add("first")
    }

    val buf = new Buffer[String]
    f(buf)
    println(buf)

  }

}
