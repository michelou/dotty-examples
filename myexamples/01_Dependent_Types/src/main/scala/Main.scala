package myexamples

object Main {

  trait Key { type Value }

  class HMap {
    import scala.collection.mutable.HashMap
    private val m = HashMap.empty[Key, Any]
    def get(key: Key): Option[key.Value] = m get key match {
      case None => None
      case Some(x) => Some(x.asInstanceOf[key.Value])
    }
    def add(key: Key)(value: key.Value): HMap = {
      m += (key -> value)
      this
    }
    override def toString: String = m.toString()
  }
  object HMap {
    def empty: HMap = new HMap
  }

  val sort = new Key { type Value = String; override def toString = "sort" }
  val width = new Key { type Value = Int; override def toString = "width" }
  val grade = new Key { type Value = Char; override def toString = "grade" }

  def main(args: Array[String]): Unit = {
    val params = HMap.empty
      .add(width)(120)
      .add(sort)("time")
      .add(grade)('C')
    println(s"params=$params")
  }

}
