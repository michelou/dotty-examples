val dottyVersion = "3.0.2-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Type Lambdas Underscore",
    description := "sbt example project to build/run Scala 3 applications",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
	  "-feature",
      "-encoding", "UTF-8"
    )
  )
