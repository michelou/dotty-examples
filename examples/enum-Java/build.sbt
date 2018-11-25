val dottyVersion = "0.10.0"

lazy val root = project
  .in(file("."))
  .settings(
    name := "enum-Java",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    )
  )
