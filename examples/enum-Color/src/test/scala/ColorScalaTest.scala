// http://www.scalatest.org/user_guide/selecting_a_style

import org.scalatest.FunSuite

class ColorScalaTest extends FunSuite {
  test("Enumeration contains 3 colors") {
    assert(Color.values.size == 4)
  }
}
