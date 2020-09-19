package dividezero

import scala.language.implicitConversions

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

class DivideZero extends PluginPhase with StandardPlugin {
  val name: String = "divideZero"
  override val description: String = "divide by zero check"

  val phaseName = name

  // see ordering of compiler phases in file dotty.tools.dotc.Compiler.scala
  // no error output
  //override val runsAfter = Set(Pickler.name)
  //override val runsBefore = Set(ReifyQuotes.name) // or Set("firstTransform")

  // no error output
  //override val runsAfter = Set(ReifyQuotes.name)
  //override val runsBefore = Set("checkReentrant") // or Set("checkStatic") or Set("betaReduce")

  // Exception: assertion failed: phase divideZero has unmet requirement: firstTransform should precede this phase
  //override val runsAfter = Set("firstTransform")
  //override val runsBefore = Set("checkStatic") // or Set("checkReentrant") or Set("betaReduce")

  // WITH error output !!!
  override val runsAfter = Set("firstTransform") // or Set(Pickler.name) or Set(ReifyQuotes.name)
  override val runsBefore = Set(typer.RefChecks.name) // or Set("erasure")

  override def init(options: List[String]): List[PluginPhase] = this :: Nil

  private val paths = List("scala.Int", "scala.Long", "scala.Short", "scala.Float", "scala.Double")

  private def isNumericDivide(sym: Symbol)(using Context): Boolean = {
    inline def isNumeric(s: Symbol) = paths.exists(s eq requiredClass(_))
    sym.name == nme.DIV && isNumeric(sym.owner)
  }

  override def transformApply(tree: tpd.Apply)(using Context): tpd.Tree = tree match {
    case tpd.Apply(fun, tpd.Literal(Constant(0)) :: Nil) if isNumericDivide(fun.symbol) =>
      report.error("divide by zero", tree.sourcePos)
      tree
    case _ =>
      tree
  }
}
