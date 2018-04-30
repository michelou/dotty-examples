lazy val root = (project in file(".")).
  settings(
    name := "enum-Tree",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1",

    scalaVersion := "0.8.0-RC1",
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    )
  )
