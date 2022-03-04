// see https://blog.rockthejvm.com/type-level-programming-part-1/
package rockthejvm

object TypeLevelProgramming {
  import scala.reflect.runtime.universe._

  def show[T](value: T)(implicit tag: TypeTag[T]) =
    tag.toString().replace("content.TypeLevelProgramming.", "")

}

object Main {
  import TypeLevelProgramming._

  def main(args: Array[String]): Unit = {
    println(show(List(1, 2, 3)))
  }

}
