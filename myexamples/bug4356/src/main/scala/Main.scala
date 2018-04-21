import org.junit._

object Main {
  def main(args: Array[String]): Unit = {
    Assert.assertTrue(args.length > 0)
    println("Got one or more arguments")
  }
}
