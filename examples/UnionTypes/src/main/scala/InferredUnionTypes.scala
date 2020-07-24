/**
  * Union Types: http://dotty.epfl.ch/docs/reference/new-types/union-types-spec.html
  */
import scala.collection.mutable._
import scala.language.implicitConversions

object InferredUnionTypes {

  type T = Either[Int, String]
  type U = Option[Int | String]
  type A[X] = Array[List[X | Boolean]]

  def test: Unit = {
    val x = ListBuffer(Right("foo"), Left(0))
    val y: ListBuffer[T] = x
    println("y=" + y)

    val x2 = ArrayBuffer(Some(0), Some("hello"), None)
    val y2: ArrayBuffer[U] = x2
    println("y2=" + y2)

    val x3 = Array(List("-deprecation", "-feature"), List(true))
    val y3: A[String] = x3
    println("y3=" + y3)
  }

}
