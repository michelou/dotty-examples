import mill._, scalalib._
import $file.^.common

object javaApp extends JavaModule {

  def mainClass = T.input {
    Some(common.getBuildProp("javaMainClassName", "EnumTest", T.ctx))
  }

  def sources = T.sources { common.javaSourcePath }
}

object app extends ScalaModule {
  def moduleDeps = Seq(javaApp)

  def scalaVersion = common.scalaVersion
  def scalacOptions = common.scalacOptions

  def forkArgs = common.forkArgs

  def mainClass = T.input {
    Some(common.getBuildProp("mainClassName", "Test", T.ctx))
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
      "org.scalatest.tools.Framework"
    )

  }

}
