import dotty.tools._

object Main {
  def main(args: Array[String]): Unit = {
    println("1111111111")
    val test = new DottyTest
    println("2222222222")
    val ctx = test.checkCompile("typechecker", "class A")
    println("3333333333 " + ctx)
  }
}
