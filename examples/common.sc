import mill._, scalalib._

//////////////////////////////////////////////////////////////////////////////
// Project properties

val scalaVersion = "0.24.0-RC1"  // "2.12.18"
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
val ivyScalatest = ivy"org.scalatest:scalatest_2.13:3.1.1"

// https://mvnrepository.com/artifact/org.scalactic/scalactic_2.13
val ivyScalactic = ivy"org.scalactic:scalactic_2.13:3.1.1"

// https://mvnrepository.com/artifact/org.specs2/specs2-common
val ivySpecs2Common = ivy"org.specs2:specs2-common_2.13:4.9.4"

// https://mvnrepository.com/artifact/org.specs2/specs2-core
val ivySpecs2Core = ivy"org.specs2:specs2-core_2.13:4.9.4"
