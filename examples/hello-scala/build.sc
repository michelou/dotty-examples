import mill._, scalalib._
import $file.^.common

object javaApp extends JavaModule {
  def mainClass =
    T.input {
      Some(common.getBuildProp("mainClassName", "Main", T.ctx()))
    }
  def sources = T.sources { common.javaSourcePath }
}

object app extends ScalaModule {
  def moduleDeps = Seq(javaApp)

  def scalaVersion = common.scalaVersion
  def scalacOptions = common.scalacOptions

  def forkArgs = common.forkArgs

  def mainClass =
    T.input {
      Some(common.getBuildProp("mainClassName", "hello", T.ctx()))
    }

  def sources = T.sources { common.scalaSourcePath }
  // def resources = T.sources { os.pwd / "resources" }
  // def runClasspath = super.runClasspath() ++ sources()

  def clean() =
    T.command {
      val path = os.pwd / "out" / "app"
      os.walk(path, skip = _.last == "clean").foreach(os.remove.all)
    }

  // https://mill-build.com/mill/Scala_Module_Config.html#_test_dependencies
  object test extends ScalaTests {
    def ivyDeps =
      Agg(
        common.ivyJunitInterface,
        //common.ivyScalatest,
        //common.ivySpecs2Common,
        //common.ivySpecs2Core,
        //common.ivySpecs2JUnit
      )
    // def testFrameworks =
      // Seq(
        // "com.novocode.junit.JUnitFramework",
        // "org.scalatest.tools.Framework"
        // // "org.specs2.runner.JUnitRunner",
        // // "org.specs2.Specs2Framework"
      // )
    def testFramework = "com.novocode.junit.JUnitFramework"
    //def moduleDeps = super.moduleDeps ++ Seq(baz.test)
  }
}
