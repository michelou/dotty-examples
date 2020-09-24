//trait RichStrings[T] {
//  def (value: T) underscorize: String
//}

object StringDelegates {
  extension (value: String)
    def underscorize: String = value.map(v => s"${v}_").foldLeft("")((a, b) => a + b)
}

object AnotherStringDelegates {
  extension (value: String)
    def underscorize: String = value.map(v => s"${v}-").foldLeft("")((a, b) => a + b)
}

object test1 {
  import StringDelegates._

  println("Harry".underscorize)
}

object test2 {
  extension (value: String)
    def underscorize: String = value.map(v => s"${v}*").foldLeft("")((a, b) => a + b)

  println("Harry".underscorize)
}

object ImplicitDemo extends App {
  test1
  test2
}
