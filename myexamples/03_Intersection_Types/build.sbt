val dottyVersion = "0.16.0-RC2"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Intersection Types",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation"
    ),

    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
