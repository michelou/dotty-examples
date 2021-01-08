/**
 * Structural Types: https://dotty.epfl.ch/docs/reference/other-new-features/trait-parameters.html
 */
object StructuralTypes:

  case class Record(elems: (String, Any)*) extends Selectable:
    def selectDynamic(name: String): Any = elems.find(_._1 == name).get._2

  type Person = Record {
    val name: String
    val age: Int
  }

  val person =
    Record("name" -> "Emma", "age" -> 42, "salary" -> 320L).asInstanceOf[Person]

  val invalidPerson =
    Record("name" -> "John", "salary" -> 42).asInstanceOf[Person]

  def test: Unit =
    println(person.name)
    println(person.age)

    println(invalidPerson.name)
    // age field is java.util.NoSuchElementException: None.get
    //println(invalidPerson.age)
