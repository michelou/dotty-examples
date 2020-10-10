// see: https://docs.oracle.com/javase/tutorial/java/javaOO/enum.html

object PlanetEnum extends Enumeration {
  case class PlanetVal(i: Int, name: String, mass: Double, radius: Double) extends Val(i, name) {
    private final val G = 6.67300E-11
    def surfaceGravity = G * mass / (radius * radius)
    def surfaceWeight(otherMass: Double) =  otherMass * surfaceGravity
  }
  val MERCURY = PlanetVal(0, "MERCURY", 3.303e+23, 2.4397e6)
  val VENUS   = PlanetVal(1, "VENUS"  , 4.869e+24, 6.0518e6)
  val EARTH   = PlanetVal(2, "EARTH"  , 5.976e+24, 6.37814e6)
  val MARS    = PlanetVal(3, "MARS"   , 6.421e+23, 3.3972e6)
  val JUPITER = PlanetVal(4, "JUPITER", 1.9e+27,   7.1492e7)
  val SATURN  = PlanetVal(5, "SATURN" , 5.688e+26, 6.0268e7)
  val URANUS  = PlanetVal(6, "URANUS" , 8.686e+25, 2.5559e7)
  val NEPTUNE = PlanetVal(7, "NEPTUNE", 1.024e+26, 2.4746e7)
}

object Planet {
  import PlanetEnum._
  def main(args: Array[String]) = {
    val earthWeight = args(0).toDouble
    val mass = earthWeight / EARTH.surfaceGravity
    println(s"Mass of earth is $mass")
    for (p <- values)
      println(s"Your weight on $p (${p.id}) is ${p.asInstanceOf[PlanetVal].surfaceWeight(mass)}")
  }
}
