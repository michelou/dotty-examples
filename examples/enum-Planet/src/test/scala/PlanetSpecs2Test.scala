// https://www.playframework.com/documentation/2.8.x/ScalaTestingWithSpecs2

import org.junit.runner.RunWith
import org.specs2.mutable.Specification
import org.specs2.runner.JUnitRunner

import scala.language.implicitConversions

@RunWith(classOf[JUnitRunner])
class PlanetSpecs2Test extends Specification {
  override def is = "This is a specification of enumeration Planet"

  "Enumeration" should {
    "contain 8 planets" in {
      Planet.values.size must_== 8
    }
  }
}
