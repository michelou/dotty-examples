trait RichStrings[T] {
  def (value: T) underscorize: String
}

object StringDelegates {
  delegate StringDelegate for RichStrings[String] {
    def (value: String) underscorize: String = value.map(v => s"${v}_").foldLeft("")((a, b) => a + b)
  }
}

object AnotherStringDelegates {
  delegate AnotherStringDelegate for RichStrings[String] {
    def (value: String) underscorize: String = value.map(v => s"${v}_").foldLeft("")((a, b) => a + b)
  }
}

object ImplicitDemo extends App {
  import delegate StringDelegates._

  delegate AnotherStringDelegate for RichStrings[String] {
    def (value: String) underscorize: String = value.map(v => s"${v}*").foldLeft("")((a, b) => a + b)
  }

  println("Harry".underscorize)
}
