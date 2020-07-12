object Main extends App {
  val xs = List(1, 2, 3, 4, 5)
  val ys = List(1, 2, 3, 4, 5, 8)

  println("Given:")
  println(s"   xs = ${xs}")
  println(s"   ys = ${ys}")
  println
  println(s"P01.lastBuiltin(${xs}) = ${P01.lastBuiltin(xs)}")
  println
  println(s"P02.penultimateBuiltin(${ys}) = ${P02.penultimateBuiltin(ys)}")
  println(s"P02.lastNthBuiltin(2, ${ys}) = ${P02.lastNthBuiltin(2, ys)}")
  println
  println(s"P03.nthBuiltin(2, ${ys}) = ${P03.nthBuiltin(2, ys)}")
  println(s"P03.nthRecursive(2, ${ys}) = ${P03.nthRecursive(2, ys)}")
  println
  println(s"P04.lengthBuiltin(${xs}) = ${P04.lengthBuiltin(xs)}")
}