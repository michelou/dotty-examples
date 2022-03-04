// see https://blog.rockthejvm.com/scala-3-traits/
package rockthejvm

trait Talker(val subject: String):
  def talkWith(another: Talker): String

case class Person(name: String)

class RockFan(name: String) extends Person(name), Talker("rock"):
  def talkWith(another: Talker): String =
    val otherName = another match
      case Person(n) => n
      case _ => another.toString
    s"$name talks about $subject with $otherName"

class RockFanatic(name: String) extends RockFan(name), Talker: // must not pass argument 
  override def talkWith(another: Talker): String =
    val otherName = another match
      case Person(n) => n
      case _ => another.toString
    s"$name talks for hours about $subject with $otherName"

trait Color
case object Red extends Color
case object Green extends Color
case object Blue extends Color

@main def Main: Unit =
  val bob  = RockFan("Bob")
  val john = RockFan("John")
  val tom  = RockFanatic("Tom")

  println(bob.talkWith(john))
  println(tom.talkWith(john))
  println

  val color = if (43 > 2) Red else Blue

  println(s"color=$color")
