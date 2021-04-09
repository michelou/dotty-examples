/**
 * Type Aliases: https://underscore.io/blog/posts/2016/12/05/type-lambdas.html
 */
object TypeAliases {

  type L = List[Option[(Int, Double)]]

  // scala 2 and 3
  def test_1: Unit = {
    val x: L = List(Some(11, 0.1))
    x.head match {
      case Some(a) => println(a._1)
      case None => println("None")
    }
  }

  // scala 3 only
  def test_2: Unit = {
    val x: L = List(Some(11, 0.1))
    x.head match {
      case Some(a, b) => println(a)
      case None => println("None")
    }
  }

  def test: Unit = {
    test_1
    test_2
  }

}
