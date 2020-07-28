package multiplyone

import dotty.tools.dotc._
import ast.Trees._
import ast.tpd
import core.Constants.Constant
import core.Contexts.Context
import core.Decorators._
import core.StdNames._
import core.Symbols._
import plugins.{PluginPhase, StandardPlugin}
import transform.{Pickler, ReifyQuotes}

class MultiplyOne extends PluginPhase with StandardPlugin {
  val name: String = "multiplyOne"
  override val description: String = "multiply by one elimination"
  override val optionsHelp = Some("opt1,opt2")

  val phaseName = name

  override val runsAfter = Set(Pickler.name)
  override val runsBefore = Set(ReifyQuotes.name)

  override def init(options: List[String]): List[PluginPhase] = {
    //println("111111111111 init: options="+options.mkString(","))
    this :: Nil
  }

  private val paths = List("scala.Int", "scala.Long", "scala.Short", "scala.Float", "scala.Double")

  private def isNumeric(sym: Symbol)(implicit ctx: Context): Boolean =
    paths.exists(sym.owner eq requiredClass(_))

  override def transformApply(tree: tpd.Apply)(using Context): tpd.Tree = tree match {
    case tpd.Apply(fun @ tpd.Select(qual, nme.MUL), tpd.Literal(Constant(1)) :: Nil) if isNumeric(fun.symbol) =>
      report.warning("multiply by one", tree.sourcePos)
      qual
    case tpd.Apply(fun @ tpd.Select(tpd.Literal(Constant(1)), nme.MUL), v :: Nil) if isNumeric(fun.symbol) =>
      report.warning("multiply by one", tree.sourcePos)
      v
    case _ =>
      tree
  }
}
