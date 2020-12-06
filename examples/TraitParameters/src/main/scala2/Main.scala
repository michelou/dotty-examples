// see https://dotty.epfl.ch/docs/reference/other-new-features/trait-parameters.html
object Main {

  trait Greeting {
    val name: String
    def msg = s"How are you, $name"
  }

  trait FormalGreeting extends Greeting {
    override def msg = s"How do you do, $name"
  }

  class C extends Greeting {
    val name = "Bob"
    println("["+classOf[C]+"] "+msg)
  }

  class E1 extends Greeting with FormalGreeting {
    val name = "Bob"
    println("["+classOf[E1]+"] "+msg)
  }

  class E2 extends FormalGreeting with Greeting {
    val name = "Bob"
    println("["+classOf[E2]+"] "+msg)
  }

  class TitleGreeting(val title: String) extends FormalGreeting with Greeting {
    val name = s"$title Bob"
    override def msg = s"How are you, $name"
  }

  class E3 extends TitleGreeting("Mr") {
    println("["+classOf[E3]+"] "+msg)
  }

  def main(args: Array[String]): Unit = {
    new C
    new E1
    new E2
    new E3
  }
}
