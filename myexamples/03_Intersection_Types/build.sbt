val dottyVersion = "0.18.1-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Intersection Types",
    description := "sbt example project to build/run Scala 3 code",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8",
      "-feature"
    ),

    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
