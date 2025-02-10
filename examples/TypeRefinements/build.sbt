val scala3Version = "3.3.5" // = dottyLatestNightlyBuild.get 

lazy val root = project
  .in(file("."))
  .settings(
    name := "TypeRefinements",
    description := "sbt example project to build/run Scala 3 applications",
    organization := "Stéphane Micheloud",
    version := "0.1.0",
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
