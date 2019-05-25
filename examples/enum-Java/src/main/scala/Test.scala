trait WeekDay {
  case A
}
enum WorkingDay extends WeekDay {
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
    println(WeekDay.A)
    println(WorkingDay.SUNDAY)
  }
}
