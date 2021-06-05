object Color extends Enumeration {
  protected case class Color(val x: Int) extends Val
  val Green = Color(3)
  val Red = Color(2)
  val Violet = Color(Green.x + Red.x)
}

object Main {
  sealed abstract class Color(val x: Int)
  case object Green extends Color(3)
  case object Red extends Color(2)
  case object Violet extends Color(Green.x + Red.x)

  def main(args: Array[String]): Unit = {
    println(Color.Green)
    println(Color.Green.x)
    println(Color.Violet.x)
    println(Main.Green)
    println(Main.Green.x)
  }

}
