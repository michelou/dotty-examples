// adapted from https://blog.rockthejvm.com/type-level-programming-part-2/
package rockthejvm

object TypeLevelProgramming:
  import scala.reflect.runtime.universe._
  def show[T](value: T)(implicit tag: TypeTag[T]) =
    tag.toString.replace("rockthejvm.TypeLevelProgramming.", "")
