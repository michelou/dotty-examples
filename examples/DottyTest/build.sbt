val dottyVersion = "3.0.2-RC2"
// val dottyVersion = dottyLatestNightlyBuild.get 

lazy val root = project
  .in(file("."))
  .settings(
    name := "DottyTest",
    description := "sbt example project to build/run Scala 3 applications",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8",
      "-feature"
    ),

    // https://mvnrepository.com/artifact/com.novocode/junit-interface
    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
