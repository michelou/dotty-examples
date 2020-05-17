import mill._, scalalib._
import $file.^.common

object app extends ScalaModule {
  def scalaVersion = common.scalaVersion
  def scalacOptions = common.scalacOptions

  def forkArgs = common.forkArgs

  def mainClass = T.input {
    Some(common.getBuildProp("mainClassName", "Planet", T.ctx))
  }

  def sources = T.sources { common.scalaSourcePath }
  // def resources = T.sources { os.pwd / "resources" }

  def clean() = T.command {
    val path = os.pwd / "out" / "app"
    os.walk(path, skip = _.last == "clean").foreach(os.remove.all)
  }

  object test extends Tests {
    def ivyDeps = Agg(
      common.ivyJunitInterface,
      common.ivyScalatest,
      common.ivySpecs2Common,
      common.ivySpecs2Core
    )
    def testFrameworks = Seq(
      "com.novocode.junit.JUnitFramework",
      "org.scalatest.tools.Framework",
      "org.specs2.runner.JUnitRunner" // org.specs2.Specs2Framework
    )
  }
}
