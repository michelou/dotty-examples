val dottyVersion = "0.10.0-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Union Types",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1",

    //run / fork := true,
    //javaOptions ++= List("-Xms1024m", "-Xmx1024m", "-XX:ReservedCodeCacheSize=128m", "-Xss2m", "-Dfile.encoding=UTF-8"),

    scalaVersion := dottyVersion,
    scalacOptions += "-deprecation"
  )
