// http://www.scalatest.org/user_guide/selecting_a_style

import org.scalatest.funspec.AnyFunSpec

class ColorFunSpecTest extends AnyFunSpec {

  describe("Enumeration Color") {
    it("should contain 3 colors") {
      assert(Color.values.size.intValue() == 4)
    }
  }

}
