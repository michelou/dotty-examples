val dottyVersion = "0.16.0-RC3"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Multiversal Equality",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation"
    ),

    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
