//trait RichStrings[T] {
//  def (value: T) underscorize: String
//}

object StringDelegates {
  implicit class StringExtension(value: String) {
    def underscorize: String = value.map(v => s"${v}_").foldLeft("")((a, b) => a + b)
  }
}

object AnotherStringDelegates {
  implicit class AnotherStringExtension(value: String) {
    def underscorize: String = value.map(v => s"${v}-").foldLeft("")((a, b) => a + b)
  }
}

object test1 {
  import StringDelegates._

  println("Harry".underscorize)
}

object test2 {
  implicit class UnderscoreExtension(value: String) {
    def underscorize: String = value.map(v => s"${v}*").foldLeft("")((a, b) => a + b)
  }

  println("Harry".underscorize)
}

object ImplicitDemo {

  def main(arsg: Array[String]): Unit = {
    test1
    test2
  }

}
