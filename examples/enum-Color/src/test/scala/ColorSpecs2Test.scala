// https://www.playframework.com/documentation/2.8.x/ScalaTestingWithSpecs2

import org.junit.runner.RunWith
import org.specs2.mutable.Specification
import org.specs2.runner.JUnitRunner

@RunWith(classOf[JUnitRunner])
class ColorSpecs2Test extends Specification {
  override def is = "This is a specification of enumeration Color"

  "Color enumeration" should {
    "contains 4 elements" in {
      Color.values.size must beEqualTo(4)
    }
  }
}
