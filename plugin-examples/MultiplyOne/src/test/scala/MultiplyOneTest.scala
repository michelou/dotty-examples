object MultiplyOneTest {

  def twice(x: Int) = x * x

  def main(args: Array[String]): Unit = {
    val a: Int = 5
    println(a * 1)
    println(1 * a)

    println(twice(a) * 1)
    println(1 * twice(a))

    println(Math.sqrt(2) * 1)
    println(1 * Math.sqrt(2))

    // https://www.scala-lang.org/api/2.12.3/scala/collection/immutable/StringOps.html
    println("a" * 1)
    println("a" * 10)
  }

}
