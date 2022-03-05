package rockthejvm

import org.junit.Assert.assertEquals
import org.junit.Test

class MainJUnitTest:

  @Test
  def test1(): Unit =
    import Permissions._
    assertEquals("ordinal", READ.ordinal, 0)
    assertEquals("valueOf", valueOf("READ"), READ)

  @Test
  def test2(): Unit =
    import PermissionsWithBits._
    assertEquals("Read permission", READ.bits, 4)
    assertEquals("Write permission", fromBits(2), WRITE)
