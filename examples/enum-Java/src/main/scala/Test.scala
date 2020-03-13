trait WeekDay {
  case class A()
}
// see https://dotty.epfl.ch/docs/reference/enums/enums.html
enum ScalaDay extends WeekDay {
  case SUNDAY
  case MONDAY
  case TUESDAY
  case WEDNESDAY
  case THURSDAY
  case FRIDAY
  case SATURDAY
}

object Test {
  def main(args: Array[String]): Unit = {
    println(Day.SUNDAY)
    // println(WeekDay.A)
    println(ScalaDay.SUNDAY)
  }
}
