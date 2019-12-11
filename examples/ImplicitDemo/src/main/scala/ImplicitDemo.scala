trait RichStrings[T] {
  def (value: T) underscorize: String
}

object StringDelegates {
  given RichStrings[String] {
    def (value: String) underscorize: String = value.map(v => s"${v}_").foldLeft("")((a, b) => a + b)
  }
}

object AnotherStringDelegates {
  given RichStrings[String] {
    def (value: String) underscorize: String = value.map(v => s"${v}-").foldLeft("")((a, b) => a + b)
  }
}

object ImplicitDemo extends App {
  import StringDelegates.given

  given RichStrings[String] {
    def (value: String) underscorize: String = value.map(v => s"${v}*").foldLeft("")((a, b) => a + b)
  }

  println("Harry".underscorize)
}
