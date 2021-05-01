// adapted from EPFL Thesis No.7156 (2016), section 2.2.1

trait Animal { a =>
  val name: String
  type Food
  def eats(food: a.Food): Unit = println(s"$a eats $food")
  def gets: a.Food
  override def toString = name
}

trait Grass

trait Meat

// *** Scala 3 only *** extends Animal, Meat
trait Cow extends Animal with Meat {
  private val grass = new Grass { override def toString = "grass" }
  type Food = Grass
  def gets = grass
  // needed if toString overriden in Grass or Meat
  // override def toString = name
}

trait Lion extends Animal {
  private val meat = new Meat { override def toString = "meat" }
  type Food = Meat
  def gets = meat
}

object Main {

  // *** Scala 3 only *** bite: a1.Food & a2.Food
  def share(a1: Animal)(a2: Animal)(bite: a1.Food with a2.Food): Unit = {
    a1.eats(bite)
    a2.eats(bite)
  }

  def main(args: Array[String]): Unit = {
    val leo = new Lion { val name = "Leo" }
    val milka = new Cow { val name = "Milka" }
    milka.eats(milka.gets)    // prints "Milka eats grass"
    leo.eats(milka)           // prints "Leo eats Milka"

    leo.eats(leo.gets)        // prints "Leo eats meat"

    val lambda: Animal = milka
    // lambda.eats(milka)
    // type mismatch
    // -- found: Cow -- required: lambda.Food

    lambda.eats(lambda.gets)  // prints "Milka eats grass"

    val simba = new Lion { val name = "Simba" }
    share(leo)(simba)(leo.gets)  // prints "Leo eats meat" and "Simba eats meat"

    // share(leo)(lambda)(leo.gets)
    // type mismatch
    // -- found: Meat -- required: leo.Food with lambda.Food
  }

}
