import mill._, api._, scalalib._
import $file.^.common

object app extends ScalaModule {
  def scalaVersion = common.scalaVersion
  def scalacOptions = common.scalacOptions

  def forkArgs = common.forkArgs

  def mainClass = Some(getBuildProp("mainClassName", "Main"))
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
      // "org.specs2.runner.JUnitRunner",
      // "org.specs2.Specs2Framework"
    )
  }

  private var gradleProps: java.util.Properties = null
  private def getBuildProp(name: String, defaultValue: String)(implicit ctx: Ctx): String = {
    if (gradleProps == null) {
      import java.nio.file._
      gradleProps = new java.util.Properties()
      val path = Paths.get("gradle.properties")
      if (Files.isRegularFile(path)) {
        gradleProps.load(Files.newBufferedReader(path))
        ctx.log.debug(s"Path: $path")
        val os = new java.io.ByteArrayOutputStream()
        gradleProps.list(new java.io.PrintStream(os))
        ctx.log.debug(os.toString("UTF8"))
      }
    }
    gradleProps.getProperty(name, defaultValue)
  }

}
