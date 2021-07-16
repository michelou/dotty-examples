/**
  * Enum Types: http://dotty.epfl.ch/docs/reference/enums/adts.html
  */
object EnumTypes:

  enum ListEnum[+A]:
    case Cons[+A](h: A, t: ListEnum[A]) extends ListEnum[A]
    case Empty extends ListEnum[Nothing]

  // taken from: https://github.com/lampepfl/dotty/issues/1970
  enum Planet(mass: Double, radius: Double):
    private final val G = 6.67300E-11
    def surfaceGravity = G * mass / (radius * radius)
    def surfaceWeight(otherMass: Double) =  otherMass * surfaceGravity

    case MERCURY extends Planet(3.303e+23, 2.4397e6)
    case VENUS   extends Planet(4.869e+24, 6.0518e6)
    case EARTH   extends Planet(5.976e+24, 6.37814e6)
    case MARS    extends Planet(6.421e+23, 3.3972e6)
    case JUPITER extends Planet(1.9e+27,   7.1492e7)
    case SATURN  extends Planet(5.688e+26, 6.0268e7)
    case URANUS  extends Planet(8.686e+25, 2.5559e7)
    case NEPTUNE extends Planet(1.024e+26, 2.4746e7)

  def test: Unit =

    val emptyList = ListEnum.Empty
    val list = ListEnum.Cons(1, ListEnum.Cons(2, ListEnum.Cons(3, ListEnum.Empty)))
    println(emptyList)
    println(list.toString + "\n")

    def calculateEarthWeightOnPlanets(earthWeight: Double): Unit =
      val mass = earthWeight/Planet.EARTH.surfaceGravity
      for (p <- Planet.values)
        println(s"Your weight on $p is ${p.surfaceWeight(mass)}")

    calculateEarthWeightOnPlanets(80)
