object DivideZeroTest {

  def main(args: Array[String]): Unit = {
    inline val a: 1 = 1
    inline val zero = a - 1
    println(a / zero)  // error: divide by zero

    val i: Int = 1
    val l: Long = 1l
    val s: Short = 1
    val f: Float = 1.0f
    val d: Double = 1.0

    println(i / zero)  // error: divide by zero
    println(l / 0)     // error: divide by zero
    println(s / 0)     // error: divide by zero
    println(f / 0)     // error: divide by zero
    println(d / 0)     // error: divide by zero

    val x: java.lang.Integer = 1
    println(x / 0)     // error: divide by zero
    println(x / 0.0)   // error: divide by zero
  }

}
