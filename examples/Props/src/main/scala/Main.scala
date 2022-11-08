// see https://contributors.scala-lang.org/t/whitebox-macros-in-scala-3-are-possible-after-all/5014

case class User(firstName: String, age: Double)

@main def test: Unit =
  // has the type of Props { val firstName: String }
  val userProps = props[User]

  println(userProps.firstName) // prints "prop for firstName"
  // println(userProps.age) // prints "prop for age"
  // println(userProps.lastName) // compile error: value lastName is not a member of Props{firstName: String}
