object ScalaDay extends Enumeration {
  type WeekDay = Value
  val SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY = Value
}

object Test {
  def main(args: Array[String]): Unit = {
    println(Day.SUNDAY)
    println(ScalaDay.SUNDAY)
  }
}
