val dottyVersion = "0.18.1-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Union Types",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-feature"
    )

    //run / fork := true,
    //javaOptions ++= List("-Xms1024m", "-Xmx1024m", "-XX:ReservedCodeCacheSize=128m", "-Xss2m", "-Dfile.encoding=UTF-8"),
  )
