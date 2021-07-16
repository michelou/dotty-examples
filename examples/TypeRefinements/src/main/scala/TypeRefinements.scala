
object TypeRefinements {

  /**
   * see https://github.com/lampepfl/dotty/blob/master/tests/pos/refinedSubtyping.scala
   */
  class Test {
    class C { type T; type Coll }

    type T1 = C { type T = Int }
    type T11 = T1 { type Coll = Set[Int] }

    type T2 = C { type Coll = Set[T] }
    type T22 = T2 { type T = Int }

    private val y0 = new C { type T = Int; type Coll = Set[T] }
    var x: T11 = _
    var y: T22 = y0

    x = y
    y = x
  }

  class Test2 {

    trait A
    trait B

    class C { type T }

    type T1 = C { type T <: A } { type T <: B }

    type U1 = C { type T <: B } { type T <: A }

    var x: T1 = _
    var y: U1 = _

    x = y
    y = x
  }

  class Test3 {

    trait A
    trait B

    class C { type T }

    type T1 = C { type T <: A }
    type T2 = T1 { type T <: B }

    type U1 = C { type T <: B }
    type U2 = U1 { type T <: A }

    var x: T2 = _
    var y: U2 = _

    val x1 = x
    val y1 = y

    x = y
    y = x
  }

  class Test4 {

    abstract class A { type T; val xz: Any }

    val yy: A { val xz: T } = null;
    //val xx: A { val xz: T } = null;
    val zz: A { val xz: T } = yy;
  }

  def test_1a: Unit = {
    println("==== test_1a ===")
    val t = new Test
    t.x match {
       case _: Test#T11 => println("T11")
       case _: Any => println("Any")
    }
  }

  def test_2: Unit = {
    println("==== test_2 ====")
    val t = new Test2
    println("t.x="+t.x)
  }

  def test_3: Unit = {
    println("==== test_3 ====")
    val t = new Test3
    println("t.x1="+t.x1)
  }

  def test_4: Unit = {
    println("==== test_4 ====")
    val t = new Test4
    println("t.zz="+t.zz)
    //println(t.zz.xz) // java.lang.NullPointerException
    class AA extends t.A {
      type T = Int
      val xz: T = 3
    }
    val aa: t.A { type T = Int } = new AA
    println("aa.xz="+aa.xz)
  }

  def test: Unit = {
    test_1a
    test_2
    test_3
    test_4
  }

}