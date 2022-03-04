// adapted from https://blog.rockthejvm.com/scala-3-extension-methods/
package rockthejvm

case class Person(name: String):
  def greet: String = s"Hi, I'm $name, nice to meet you."

// Proper Extensions

// Scala 2
// implicit class PersonLike(string: String) {
//   def greet: String = Person(string).greet
// }

extension (str: String) 
  def greet: String = Person(str).greet

sealed abstract class Tree[+A]
case class Leaf[+A](value: A) extends Tree[A]
case class Branch[+A](left: Tree[A], right: Tree[A]) extends Tree[A]

// Generic Extensions

extension [A](tree: Tree[A])

  def filter(predicate: A => Boolean): Boolean = tree match
    case Leaf(value) => predicate(value)
    case Branch(left, right) => left.filter(predicate) || right.filter(predicate)

  def map[B](func: A => B): Tree[B] = tree match
    case Leaf(value) => Leaf(func(value))
    case Branch(left, right) => Branch(left.map(func), right.map(func))

// Extensions in the Presence of Givens

extension [A](tree: Tree[A])(using numeric: Numeric[A])
  def sum: A = tree match
    case Leaf(value) => value
    case Branch(left, right) => numeric.plus(left.sum, right.sum)

extension [A](tree: Tree[A])
  def sum1(using numeric: Numeric[A]): A = tree match
    case Leaf(value) => value
    case Branch(left, right) => numeric.plus(left.sum, right.sum)


@main def Main: Unit =
  println("Daniel".greet)

  val t1 = Branch(Leaf("a"), Leaf("b"))
  val t2 = t1.map(_.toUpperCase)
  println(s"t1=$t1")
  println(s"t2=$t2")

  val tree = Branch(Leaf(1), Leaf(2))
  val three = tree.sum
  val three1 = tree.sum1
  println(s"tree=$tree")
  println(s"three=$three")
  println(s"three1=$three1")
