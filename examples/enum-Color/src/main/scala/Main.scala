enum Color(val x: Int) {
  case Green  extends Color(3)
  case Red    extends Color(2)
  case Violet extends Color(Green.x + Red.x)
}

object Main {
  abstract class Color(val x: Int)
  case object Green  extends Color(3)
  case object Red    extends Color(2)
  case object Violet extends Color(Green.x + Red.x)

  def main(args: Array[String]): Unit = {
    println(Color.Green)
    println(Color.Green.x)
    println(Color.Violet.x)
    println(Main.Green)
    println(Main.Green.x)
  }
}
