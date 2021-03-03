package cdsexamples

object Main {
  def main(args: Array[String]): Unit = {
    println("Hello from Scala 3 !")
    if (args.length > 0) {
      //TastyTest.run()
      println(VMOptions.asString)
    }
  }
}