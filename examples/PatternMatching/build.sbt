val dottyVersion = "0.17.0-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Pattern Matching",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
	  "-feature"
    ),

    // https://mvnrepository.com/artifact/com.novocode/junit-interface
    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
