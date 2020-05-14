// https://rockthejvm.com/blog/208610/custom-interpolator
// https://youtu.be/J6Vnn7aHYAk
object Main {

  // s-interpolator
  val lifeOfPi = 3.14159
  val sInterpolator = s"The value of pi is $lifeOfPi. Half of pi is ${lifeOfPi / 2}"

  // raw-interpolator
  val rawInterpolator = raw"The value of pi is $lifeOfPi\n Half of pi is ${lifeOfPi / 2}"

  // f-interpolator
  val fInterpolator = f"The approximate value of pi is $lifeOfPi%4.2f"

  // Java printf
  val javaFormat = "The approximate value of pi is %4.2f\n"

  case class Person(name: String, age: Int)

  def stringToPerson(line: String): Person = {
    // assume the strings are always "name,age"
    val tokens = line.split(",")
    Person(tokens(0), tokens(1).toInt)
  }
  val age = 55
  val bob = stringToPerson(s"Bob,$age")

  // custom interpolator
  implicit class PersonInterpolator(sc: StringContext) {
    def person(args: Any*): Person = {
      val tokens = sc.s(args: _*).split(",")
      Person(tokens(0), tokens(1).toInt)
    }
  }
  val personInterpolator = person"Bob,$age"

  def main(args: Array[String]): Unit = {
    println(sInterpolator)
    println(rawInterpolator)
    println(fInterpolator)
    System.out.printf(javaFormat, lifeOfPi.asInstanceOf[Object])
    println(bob)
    println(personInterpolator) // Person(Bob,55)
  }

}