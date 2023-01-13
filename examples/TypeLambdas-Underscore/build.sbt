val scala3Version = "3.2.2" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "Type Lambdas Underscore",
    description := "sbt example project to build/run Scala 3 applications",
    version := "0.1.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    )
  )
