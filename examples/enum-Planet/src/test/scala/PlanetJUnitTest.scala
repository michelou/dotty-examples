// http://junit.sourceforge.net/javadoc/org/junit/Assert.html
import org.junit.Assert._
import org.junit.Test

class PlanetJUnitTest {

  @Test
  def test1(): Unit = {
    assertEquals("Enumeration contains 8 planets", Planet.values.size.toLong, 8)
  }

  private case class MyPlanet(mass: Double, radius: Double) {
    private final val G = 6.67300E-11
    def surfaceGravity = G * mass / (radius * radius)
  }

  @Test
  def test2(): Unit = {
    val myGravity = MyPlanet(3.303e+23, 2.4397e6).surfaceGravity
    assertEquals("Test should pass", Planet.MERCURY.surfaceGravity, myGravity, 0.001)
  }
}