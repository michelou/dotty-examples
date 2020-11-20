object HLst extends Enumeration {
  sealed abstract class HLst extends Val
  case class HCons[+Hd, +Tl <: HLst](hd: Hd, tl: Tl) extends HLst
  case object HNil extends HLst
}

object Main {
  import HLst._
  def length(hl: HLst): Int = hl match {
    case HCons(_, tl) => 1 + length(tl)
    case HNil => 0
  }
  def sumInts(hl: HLst): Int = hl match {
    case HCons(x: Int, tl) => x + sumInts(tl)
    case HCons(_, tl) => sumInts(tl)
    case HNil => 0
  }
  def main(args: Array[String]) = {
    val hl = HCons(1, HCons("A", HNil))
    assert(length(hl) == 2, length(hl))
    assert(sumInts(hl) == 1)
  }
}