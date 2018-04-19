/**
  * Functors: https://typelevel.org/cats/typeclasses/functor.html
  */
object Functors {

  trait Functor[F[_]] {
    def map[A, B](fa: F[A])(f: A => B): F[B]
    def lift[A, B](f: A => B): F[A] => F[B]
  }

  def test: Unit = {

    implicit val functorForOption = new Functor[Option] {
      def map[A, B](fa: Option[A])(f: A => B): Option[B] = {
        println("functorForOption: "+fa)
        fa match {
          case None => None
          case Some(a) => Some(f(a))
        }
      }
      def lift[A, B](f: A => B): Option[A] => Option[B] = fa => map(fa)(f)
    }

    implicit val functorForList = new Functor[List] {
      def map[A, B](fa: List[A])(f: A => B): List[B] = {
        println("functorForList: "+fa)
        fa match {
          case Nil => Nil
          case x :: xs => f(x) :: map(xs)(f)
        }
      }
      def lift[A, B](f: A => B): List[A] => List[B] = fa => map(fa)(f)
    }

    val listOption = List(Some(1), None, Some(2))

    println(functorForOption.map(Some(1)){ a => if (a > 0) then -a else 0 })
    println(functorForList.map(listOption){ _.getOrElse(0) })
  }

}
