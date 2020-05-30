
object Main {

  def main(args: Array[String]): Unit = {

    runExample("Trait Params")(TraitParams.test)

    runExample("Enum Types")(EnumTypes.test)

    runExample("Context Queries")(ContextQueries.test)

    runExample("Implied Instances")(ImpliedInstances.test)

    runExample("Conversion")(Conversion.test)

    runExample("Union Types")(UnionTypes.test)

    runExample("Intersection Types")(IntersectionTypes.test)

    runExample("Type Lambda")(TypeLambdas.test)

    runExample("Multiversal Equality")(MultiversalEquality.test)

    runExample("Named Type Arguments")(NamedTypeArguments.test)

    runExample("Auto Param Tupling")(AutoParamTupling.test)

    runExample("Structural Types")(StructuralTypes.test)

    runExample("Pattern Matching")(PatternMatching.test)

    //pressEnter()
  }

  private def runExample(name: String)(f: => Unit) = {
    println(Console.MAGENTA + s"$name example:" + Console.RESET)
    f
    println()
  }

  private def pressEnter(): Unit = {
    System.out.print("Press ENTER to continue")
    val input = new java.util.Scanner(System.in)
    input.nextLine()
  }

}
