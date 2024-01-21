// https://github.com/lampepfl/dotty/issues/19478#issuecomment-1900389979

trait StringValue[T]:
  def stringValue(t: T): String

given StringValue[Int] with 
  def stringValue(t: Int): String = t.toString

given StringValue[String] with
  def stringValue(t: String): String = t

extension [T: StringValue](t: T)
  def stringValue: String = summon[StringValue[T]].stringValue(t)

@main
def main = 
  println(1.stringValue)
  println("hello".stringValue)
