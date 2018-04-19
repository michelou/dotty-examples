/**
  * Type Aliases: https://underscore.io/blog/posts/2016/12/05/type-lambdas.html
  */
object TypeAliases {

  type L = List[Option[(Int, Double)]]

  // scala 2 and dotty
  def test_1a: Unit = {
    val x: L = List(Some(11, 0.1))
    x.head match {
       case Some(a) => println(a._1)
       case None => println("None")
    }
  }

  // dotty only
  def test_1b: Unit = {
    val x = List(Some(11, 0.1)) // type of x is inferred
    x.head match {
       case Some(a) => println(a._1)
       //error: pattern type is incompatible with expected type;
       // found   : None.type
       // required: Some[(Int, Double)]
       case None => println("None")
    }
  }

  // dotty only
  def test_2: Unit = {
    val x = List(Some(11, 0.1))
    x.head match {
       case Some(a, b) => println(a)
       case None => println("None")
    }
  }

  def test: Unit = {
    test_1a
    test_1b
    test_2
  }
}