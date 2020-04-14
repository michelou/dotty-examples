//trait RichStrings[T] {
//  def (value: T) underscorize: String
//}

object StringDelegates {
  extension stringOps {
    def (value: String) underscorize: String = value.map(v => s"${v}_").foldLeft("")((a, b) => a + b)
  }
}

object AnotherStringDelegates {
  extension stringOps {
    def (value: String) underscorize: String = value.map(v => s"${v}-").foldLeft("")((a, b) => a + b)
  }
}

object test1 {
  import StringDelegates.stringOps

  println("Harry".underscorize)
}

object test2 {
  extension stringOps {
    def (value: String) underscorize: String = value.map(v => s"${v}*").foldLeft("")((a, b) => a + b)
  }

  println("Harry".underscorize)
}

object ImplicitDemo extends App {
  test1
  test2
}
