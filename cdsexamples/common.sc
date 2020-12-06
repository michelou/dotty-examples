import mill._, api._, scalalib._

//////////////////////////////////////////////////////////////////////////////
// Project properties

val scalaVersion = "3.0.0-M2"  // "0.27.0-RC1", "2.12.18"
val scalacOptions = Seq("-deprecation", "-encoding", "UTF8", "-feature")

val forkArgs = Seq("-Xmx1g")
// val forkEnv = Map("ENV_VAR" -> "hello")

//////////////////////////////////////////////////////////////////////////////
// Project paths

val javaSourcePath = os.pwd / "src" / "main" / "java"
val scalaSourcePath = os.pwd / "src" / "main" / "scala"

//////////////////////////////////////////////////////////////////////////////
// Ivy dependencies

val ivyJunit = ivy"org.junit:org.junit:4.13"

val ivyJunitInterface = ivy"com.novocode:junit-interface:0.11"

// https://mvnrepository.com/artifact/org.scalatest/scalatest
val ivyScalatest = ivy"org.scalatest:scalatest_2.13:3.2.2"

// https://mvnrepository.com/artifact/org.scalactic/scalactic_2.13
val ivyScalactic = ivy"org.scalactic:scalactic_2.13:3.2.2"

// https://mvnrepository.com/artifact/org.specs2/specs2-common
val ivySpecs2Common = ivy"org.specs2:specs2-common_2.13:4.10.3"

// https://mvnrepository.com/artifact/org.specs2/specs2-core
val ivySpecs2Core = ivy"org.specs2:specs2-core_2.13:4.10.3"

// https://mvnrepository.com/artifact/org.specs2/specs2-junit_2.13
val ivySpecs2JUnit = ivy"org.specs2:specs2-junit_2.13:4.10.3"

//////////////////////////////////////////////////////////////////////////////
// Helper functions

private var gradleProps: java.util.Properties = null
def getBuildProp(name: String, defaultValue: String, ctx: Ctx): String = {
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