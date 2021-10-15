package example

sealed trait Country
object Country {
  case object IS extends Country
  case object FI extends Country
}

case class Address(street: String, zip: String, country: Country)
case class User(name: String, age: Int, address: Address)
