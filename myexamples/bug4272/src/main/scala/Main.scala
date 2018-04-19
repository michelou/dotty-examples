object Main {

  final case class C(m: Map[String, Boolean])

  def main(args: Array[String]): Unit = {
    // println(C(Map("a" -> true)))  // C(Map(a -> true))
    println(C(Map('a' -> true)))  // Scala: one error found, Dotty: runtime exception
  }

}
