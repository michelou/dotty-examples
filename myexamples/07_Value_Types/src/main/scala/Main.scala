package myexamples

object Main {

  class Meter(val underlying: Int) extends AnyVal {
    def plus(other: Meter): Meter =
      new Meter(this.underlying + other.underlying)
  }

  def main(args: Array[String]): Unit = {
    val m: Meter = new Meter(3)
    
    println(m.plus(new Meter(2)).underlying)
  }
}
