val dottyVersion = "3.2.1-RC4"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Pattern Matching",
    description := "sbt example project to build/run Scala 3 applications",
    version := "0.1.0",
    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    ),
    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
