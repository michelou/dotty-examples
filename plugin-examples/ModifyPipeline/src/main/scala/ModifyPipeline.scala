package modifypipeline

import dotty.tools.dotc._
import ast.tpd
import core.Contexts.Context
import core.Phases.Phase
import plugins.{PluginPhase, ResearchPlugin}
import transform.{Pickler, Inlining}

class ModifyPipeline extends PluginPhase with ResearchPlugin {
  val name: String = "modifyPipeline"
  override val description: String = "dummy research plugin"
  override val optionsHelp = Some("opt1,opt2")

  val phaseName = name

  // see phases in file compiler\src\dotty\tools\dotc\Compiler.scala
  override val runsAfter = Set(Pickler.name)
  override val runsBefore = Set(Inlining.name)

  def init(options: List[String], phases: List[List[Phase]])(implicit ctx: Context): List[List[Phase]] = {
    println("111111111 "+options.mkString(" "))
    phases
  }

  override def transformApply(tree: tpd.Apply)(implicit ctx: Context): tpd.Tree = tree match {
    case _ =>
      println("11111111 transformApply: tree="+tree)
      tree
  }

}
