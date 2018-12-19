package cdsexamples

object TastyTest {
  def run(): Unit = {
    System.out.println("TastyTest.run")
    val r1 = 0 until 10
    val r2 = r1.start until r1.end by r1.step + 1
    println(r2.length)
  }
}
