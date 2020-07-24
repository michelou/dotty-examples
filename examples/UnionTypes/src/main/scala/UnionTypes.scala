/**
  * Union Types: http://dotty.epfl.ch/docs/reference/new-types/union-types.html
  */
object UnionTypes {
  import scala.language.implicitConversions // otherwise warning starting with version 0.9.0

  type Admin = String
  type Hash = Long | String

  class UserData {}

  case class UserName(name: String) {
    def lookup(admin: Admin): UserData = {
      return new UserData
    }
  }

  case class Password(hash: Hash) {
    def lookup(admin: Admin): UserData = {
      return new UserData
    }
  }

  def lookupName(name: String): UserData = {
    return UserName(name).lookup("admin")
  }

  def lookupPassword(hash: Hash): UserData = {
    return Password(hash).lookup("admin")
  }

  def help(id: UserName | Password) = {
    val user = id match {
      case UserName(name) => lookupName(name)
      case Password(hash) => lookupPassword(hash)
    }
    // ...
  }

  def test: Unit = {
    val password = Password(123)
    val name = UserName("Eve")
    val either: Password | UserName = if (true) name else password
    println(s"either=$either")
  }

}
