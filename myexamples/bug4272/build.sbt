val dottyVersion = "0.9.0-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "bug 4272",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation"
    ),

    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
