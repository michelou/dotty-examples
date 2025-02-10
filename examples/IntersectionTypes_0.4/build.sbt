val scala3Version = "3.3.5"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Intersection Types",
    description := "Example sbt project that compiles using Dotty",
    organization := "Stéphane Micheloud",
    version := "1.0.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    ),
    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/com.github.sbt/junit-interface
      "com.github.sbt" % "junit-interface" % "0.13.3" % "test"
    )
  )
