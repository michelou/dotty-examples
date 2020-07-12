package myexamples

object testIntFloat {

  type IntFloat = Integer | Float

  def printValue(value: IntFloat): Unit = {
    value match {
      case i: Integer => println(s"Integer $i")
      case f: Float => println(s"Float $f")
    }
  }

  def run: Unit = {
    println("testIntFloat example:")
    printValue(0.0f)  // Float 0.0
    printValue(1 + 3) // Integer 4
    println()
  }

}

// see https://www.typescriptlang.org/docs/handbook/advanced-types.html
object testPadding {
  /**
   * Takes a string and adds "padding" to the left.
   * If 'padding' is a string, then 'padding' is appended to the left side.
   * If 'padding' is a number, then that number of spaces is added to the left side.
   */
  def padLeft(value: String, padding: String | Int): String = padding match {
    case s: String => s + value
    case i: Int => s"%${i}s".format(value)
  }

  def run: Unit = {
    println("testPadding example:")
    println(padLeft("abc", "01234")) // "01234abc"
    println(padLeft("abc", 8))       // "     abc"
    println()
  }

}

// see https://www.schoolofhaskell.com/school/to-infinity-and-beyond/pick-of-the-week/sum-types
object testDivision {
  import scala.language.implicitConversions // otherwise warning starting with version 0.9.0

  sealed trait DivisionByZero
  case object DivisionByZero extends DivisionByZero
  final case class Success(result: Double)
  type DivisionResult = DivisionByZero | Success

  def saveDivide(x: Double, y: Double): DivisionResult =
    if (y == 0) DivisionByZero else Success(x / y)

  def run: Unit = {
    println("testDivision example:")
    println(saveDivide(1, 2)) // Success(0.5)
    println(saveDivide(1, 0)) // DivisionByZero

    implicit def divisionToString(result: DivisionResult): String = result match {
      case DivisionByZero => "Division failed"
      case Success(r)     => r.toString
    }
    def printString(s: String): Unit = println(s)

    printString(saveDivide(1, 2)) // 0.5
    printString(saveDivide(1, 0)) // Division failed
    println()
  }

}

// see http://whiley.org/2016/12/09/understanding-effective-unions-in-whiley/
object testMessage {

  val GET = 1
  case class Request(method: Int, data: java.net.URL)
  case class Response(code: Int, data: Array[Byte])
  type Message = Request | Response

  def handleMessage(m: Message): java.net.URL | Array[Byte] =
    m match {
      case Request(method, data) => data
      case Response(code, data) => data
    }
  
  def run: Unit = {
    println("testMessage example:")
    val data = handleMessage(Request(GET, new java.net.URL("https://www.google.com")))
    println(data)
    handleMessage(Response(200, "Dotty".getBytes("UTF-8"))) match {
      case a: Array[Byte] => println(new String(a))
      case _ => println("type error")
    }
    println()
  }
  
}

// see https://stackoverflow.com/questions/5653678/union-types-and-intersection-types
object testJSON {

  sealed trait Json
  final case class JObject(props: Map[String, JValue]) extends Json
  final case class JArray(elems: JValue*) extends Json

  type JValue = String | Number | Boolean | JObject | JArray

  def stringify(json: JValue): String = json match {
    case s: String => s"""$s"""
    case i: Number => json.toString()
    case b: Boolean => json.toString()
    case o: JObject => "{" + o.props.keys.map(x => x + ": " + stringify(o.props(x))).mkString(", ") + "}"
    case a: JArray => "[" + a.elems.map(stringify).mkString(", ") + "]"
  }

  def run: Unit = {
    println("testJSON example:")
    val a = JArray(1, "abc", true)
    println(stringify(1)) // 1
    println(stringify(a)) // [1, "abc", true]
    println(stringify(JObject(Map("a" -> 1, "b" -> "blue", "c" -> a))))
    // {a: 1, b: "blue", c: [1, "abc", true]}
    println()
  }

}

// see https://www.typescriptlang.org/docs/handbook/advanced-types.html
object testShape {

  trait Square {
    def size = 3
  }

  trait Rectangle {
    def width = 2
    def height = 3
  }

  type Shape = Square | Rectangle

  def area(s: Shape): Int = s match {
    case s: Square => s.size * s.size
    case r: Rectangle => r.width * r.height
  }
    
  def run: Unit = {
    println("testShape example:")
    val s = new Square {}
    println(area(s))
    println()
  }

}

object Main extends App {
  testIntFloat.run
  testPadding.run
  testDivision.run
  testMessage.run
  testJSON.run
  testShape.run
}
