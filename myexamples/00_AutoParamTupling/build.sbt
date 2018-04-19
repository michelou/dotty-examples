lazy val root = (project in file(".")).
  settings(
    name := "Automatic Parameter Tupling",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1",

    scalaVersion := "0.7.0-RC1",
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    )
  )