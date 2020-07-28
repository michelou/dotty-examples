val dottyVersion = "0.26.0-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Value Types",
    description := "sbt example project to build/run Scala 3 applications",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation"
    ),

    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
