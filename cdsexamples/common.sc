import mill._, api._, scalalib._

//////////////////////////////////////////////////////////////////////////////
// Project properties

val scalaVersion = "3.0.2-RC1"  // "3.0.1", "3.0.0", "0.27.0-RC1", "2.12.18"
val scalacOptions = Seq("-deprecation", "-encoding", "UTF8", "-feature")

val forkArgs = Seq("-Xmx1g")
// val forkEnv = Map("ENV_VAR" -> "hello")

//////////////////////////////////////////////////////////////////////////////
// Project paths

val javaSourcePath = os.pwd / "src" / "main" / "java"
val scalaSourcePath = os.pwd / "src" / "main" / "scala"

//////////////////////////////////////////////////////////////////////////////
// Ivy dependencies

val scalaBinaryVersion = "2.13"

val junitVersion = "4.13.2"
val scalatestVersion = "3.2.9"
val specs2Version = "4.12.3"

// https://mvnrepository.com/artifact/junit/junit
val ivyJunit = ivy"org.junit:org.junit:$junitVersion"

// https://mvnrepository.com/artifact/com.novocode/junit-interface
val ivyJunitInterface = ivy"com.novocode:junit-interface:0.11"

// https://mvnrepository.com/artifact/org.apiguardian/apiguardian-api
val ivyApiGuardian = ivy"org.apiguardian:apiguardian-api:1.1.1"

// https://mvnrepository.com/artifact/org.junit.jupiter/junit-jupiter-api
val ivyJunitJupiter = ivy"org.junit.jupiter:junit-jupiter-api:5.7.2"

// https://mvnrepository.com/artifact/org.scalatest/scalatest
val ivyScalatest = ivy"org.scalatest:scalatest_3:$scalatestVersion"

// https://mvnrepository.com/artifact/org.scalactic/scalactic
val ivyScalactic = ivy"org.scalactic:scalactic_3:$scalatestVersion"

// https://mvnrepository.com/artifact/org.specs2/specs2-common
val ivySpecs2Common = ivy"org.specs2:specs2-common_$scalaBinaryVersion:$specs2Version"

// https://mvnrepository.com/artifact/org.specs2/specs2-core
val ivySpecs2Core = ivy"org.specs2:specs2-core_$scalaBinaryVersion:$specs2Version"

// https://mvnrepository.com/artifact/org.specs2/specs2-junit
val ivySpecs2JUnit = ivy"org.specs2:specs2-junit_$scalaBinaryVersion:$specs2Version"

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
