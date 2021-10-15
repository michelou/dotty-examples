package example

object Example {

  def main(args: Array[String]): Unit = {
    val users = List(
      User(
        name = "John",
        age = 42,
        address = Address(
          street = "Address",
          zip = "101",
          country = Country.IS
        )
      )
    )
    users.foreach { user =>
      println(user.name)
    }
  }

}
