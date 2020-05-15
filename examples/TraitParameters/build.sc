import mill._, scalalib._
import $file.^.common

object app extends ScalaModule {
  def scalaVersion = common.scalaVersion
  def scalacOptions = common.scalacOptions

  def forkArgs = common.forkArgs

  def mainClass = Some(gradleProperties.getProperty("mainClassName", "Main"))
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

  private lazy val gradleProperties: java.util.Properties = {
    import java.nio.file._
    val props = new java.util.Properties()
    val path = Paths.get("gradle.properties")
    if (Files.isRegularFile(path)) {
      props.load(Files.newBufferedReader(path))
      //val debugLog = ammonite.main.Cli.genericSignature.exists(_.name == "debug")
      //System.out.println(s"debugLog=$debugLog")
      //if (debugLog) {
      //  System.out.println(s"Path: $path")
      //  props.list(System.out)
      //}
    }
    props
  }

}
