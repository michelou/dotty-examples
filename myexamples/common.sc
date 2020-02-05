import mill._, scalalib._

//////////////////////////////////////////////////////////////////////////////
// Project properties

val scalaVersion = "0.22.0-RC1"  // "2.12.18"
val scalacOptions = Seq("-deprecation", "-encoding", "UTF8", "-feature")

val forkArgs = Seq("-Xmx1g")
// val forkEnv = Map("ENV_VAR" -> "hello")

//////////////////////////////////////////////////////////////////////////////
// Project paths

val javaSourcePath = os.pwd / "src" / "main" / "java"
val scalaSourcePath = os.pwd / "src" / "main" / "scala"

//////////////////////////////////////////////////////////////////////////////
// Ivy dependencies

val ivyJunit = ivy"org.junit:org.junit:4.12"

val ivyJunitInterface = ivy"com.novocode:junit-interface:0.11"

val ivyApiGuardian = ivy"org.apiguardian:apiguardian-api:1.1.0"

val ivyJunitJupiter = ivy"org.junit.jupiter:junit-jupiter-api:5.5.2"

// https://mvnrepository.com/artifact/org.scalatest/scalatest
val ivyScalatest = ivy"org.scalatest:scalatest_2.13:3.1.0"

// https://mvnrepository.com/artifact/org.scalactic/scalactic_0.17
val ivyScalactic = "org.scalactic:scalactic_0.17:3.1.0"

// https://mvnrepository.com/artifact/org.specs2/specs2-core
val ivySpecs2 = ivy"org.specs2:specs2-core_2.13:4.8.1"
