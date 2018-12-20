package cdsexamples

object Main {
  def main(args: Array[String]): Unit = {
    println("Hello from Dotty !")
    if (args.nonEmpty) {
      //TastyTest.run()
      println(VMOptions.asString)
    }
  }
}