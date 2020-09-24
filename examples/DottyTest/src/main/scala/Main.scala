import dotty.tools._

object Main {

  def main(args: Array[String]): Unit = {
    val test = new DottyTest
    val ctx = test.checkCompile("typechecker", "class A")
    println(s"ctx=$ctx")
  }

}
