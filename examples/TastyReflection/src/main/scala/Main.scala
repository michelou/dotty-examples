// https://dotty.epfl.ch/docs/reference/metaprogramming/tasty-reflect.html

object Main {
  import Macros._

  def main(args: Array[String]): Unit = {
    val x = 4
    println(x)
    println(natConst(4))
  }

}
