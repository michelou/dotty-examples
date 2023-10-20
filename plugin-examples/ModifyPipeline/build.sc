import mill._, scalalib._
import mill.modules.Assembly._
import $file.^.common

object app extends ScalaModule {
  def scalaVersion = common.scalaVersion
  def scalacOptions = common.scalacOptions ++ Seq("-language:implicitConversions")

  def forkArgs = common.forkArgs

  def assemblyRules = Seq()

  def mainClass = T.input {
    Some(common.getBuildProp("mainClassName", "Main", T.ctx()))
  }

  def sources = T.sources { common.scalaSourcePath }

  // def resources = T.sources { os.pwd / "resources" }

  def clean() = T.command {
    val path = os.pwd / "out" / "app"
    os.walk(path, skip = _.last == "clean").foreach(os.remove.all)
  }

  // https://mill-build.com/mill/Scala_Module_Config.html#_test_dependencies
  object test extends ScalaTests {
    val pluginName = "divideZero"

    def scalacOptions = common.scalacOptions ++ Seq(
      s"-Xplugin:target\\classes\\${pluginName}.jar",
      s"-Xplugin-require:${pluginName}",
      s"-P:${pluginName}:opt1=1"
    )

    def ivyDeps = Agg(
      common.ivyJunitInterface,
      //common.ivyScalatest,
      //common.ivySpecs2Common,
      //common.ivySpecs2Core
    )
    // def testFrameworks = Seq(
      // "com.novocode.junit.JUnitFramework",
      // "org.scalatest.tools.Framework",
      // "org.specs2.runner.JUnitRunner" // org.specs2.Specs2Framework
    // )
    def testFramework = "com.novocode.junit.JUnitFramework"
    //def moduleDeps = super.moduleDeps ++ Seq(baz.test)
  }

}
