// adapted from https://blog.rockthejvm.com/scala-3-type-lambdas/
package rockthejvm

trait Monad[M[_]]:
  def pure[A](a: A): M[A]
  def flatMap[A, B](m: M[A])(f: A => M[B]): M[B]

class EitherMonad[T] extends Monad[[E] =>> Either[T, E]]:
  def pure[A](a: A): Either[T, A] = Right(a)
  def flatMap[A, B](m: Either[T, A])(f: A => Either[T, B]): Either[T, B] = m match
    case Left(x) => Left(x)
    case Right(x) => f(x)

@main def Main: Unit =
  val m = EitherMonad[Int]
  val x = m.pure(2)

  println(s"m=$m")
  println(s"x=$x")
