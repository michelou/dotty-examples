object Main {

  private def testIntFloat: Unit = {
    type IntFloat = Int | Float
    def printValue(value: IntFloat): Unit = {
      value match {
        case i: Int => println(s"Int $i")
        case f: Float => println(s"Float $f")
      }
    }

    printValue(0.0f)
    printValue(1 + 3)
  }

  // see https://www.schoolofhaskell.com/school/to-infinity-and-beyond/pick-of-the-week/sum-types
  private def testDivision: Unit = {
    sealed trait DivisionByZero
    final case object DivisionByZero extends DivisionByZero
    final case class Success(result: Double)
    type DivisionResult = DivisionByZero | Success

    def saveDivide(x: Double, y: Double): DivisionResult =
      if (y == 0) DivisionByZero else Success(x / y)

    println(saveDivide(1, 2)) // Success(0.5)
    println(saveDivide(1, 0)) // DivisionByZero

    implicit def divisionToString(result: DivisionResult): String = result match {
      case DivisionByZero => "Division failed"
      case Success(r)     => r.toString
    }
    def printString(s: String): Unit = println(s)

    printString(saveDivide(1, 2)) // 0.5
    printString(saveDivide(1, 0)) // Division failed
  }

  // see http://whiley.org/2016/12/09/understanding-effective-unions-in-whiley/
  private def testMessage: Unit = {
    val GET = 1
    case class Request(method: Int, data: java.net.URL)
    case class Response(code: Int, data: Array[Byte])
    type Message = Request | Response
    def handleMessage(m: Message): java.net.URL | Array[Byte] =
      m match {
        case Request(method, data) => data
        case Response(code, data) => data
      }
    val data = handleMessage(Request(GET, new java.net.URL("https://www.google.com")))
    println(data)
    handleMessage(Response(200, "Dotty".getBytes("UTF-8"))) match {
      case a: Array[Byte] => println(new String(a))
      case _ => println("type error")
    }
  }

  private def testJSON: Unit = {
    // see https://stackoverflow.com/questions/5653678/union-types-and-intersection-types
    sealed trait Json
    final case class JObject(props: Map[String, JValue]) extends Json
    final case class JArray(elems: JValue*) extends Json

    type JValue = String | Number | Boolean | JObject | JArray

    def stringify(json: JValue): String = json match {
      case s: String => '"'+s+'"'
      case i: Number => json.toString()
      case b: Boolean => json.toString()
      case o: JObject => "{" + o.props.map((x, y) => x + ": " + stringify(y)).mkString(", ") + "}"
      case a: JArray => "[" + a.elems.map(stringify).mkString(", ") + "]"
    }

    val a = JArray(1, "abc", true)
    println(stringify(1))
    println(stringify(a))
    println(stringify(JObject(Map("a" -> 1, "b" -> "blue", "c" -> a))))
  }

  private def runExample(name: String)(f: => Unit) = {
    println(Console.MAGENTA + s"$name example:" + Console.RESET)
    f
    println()
  }

  def main(args: Array[String]): Unit = {
    runExample("testIntFloat")(testIntFloat)
    runExample("testDivision")(testDivision)
    runExample("testMessage")(testMessage)
    runExample("testJSON")(testJSON)
  }

}
