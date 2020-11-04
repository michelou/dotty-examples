// https://dotty.epfl.ch/docs/reference/metaprogramming/tasty-reflect.html

object Macros {
  import scala.quoted._

  inline def natConst(inline x: Int): Int = ${natConstImpl('{x})}

  def natConstImpl(x: Expr[Int])(using qctx: QuoteContext): Expr[Int] = {
    import qctx.reflect._

    val xTree: Term = x.unseal
    xTree match {
      case Inlined(_, _, Literal(Constant.Int(n))) =>
        if (n <= 0) {
          report.error("Parameter must be natural number")
          '{0}
        } else {
          xTree.seal.cast[Int]
        }
      case Inlined(_,_, id @ Ident(x)) =>
        report.error(s"id=$id x=$x")
        '{0}
      case _ =>
        report.error("Parameter must be a known constant")
        '{0}
    }
  }

}
