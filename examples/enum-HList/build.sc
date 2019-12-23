import mill._, scalalib._
import $file.^.common

object app extends ScalaModule {
  def scalaVersion = common.scalaVersion
  def scalacOptions = common.scalacOptions

  def forkArgs = common.forkArgs

  def mainClass = Some("Main")
  def sources = T.sources { common.scalaSourcePath }
  // def resources = T.sources { os.pwd / "resources" }

  def clean() = T.command {
    val path = os.pwd / "out" / "app"
    os.walk(path, skip = _.last == "clean").foreach(os.remove.all)
  }

  object test extends Tests {
    def ivyDeps = Agg(
      common.ivyJunitInterface,
      common.ivyScalatest
    )
    def testFrameworks = Seq(
      "com.novocode.junit.JUnitFramework",
      "org.scalatest.tools.Framework"
    )
  }
}
