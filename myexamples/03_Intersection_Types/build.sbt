val dottyVersion = "3.1.1" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "Intersection Types",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",
    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    ),
    // https://mvnrepository.com/artifact/com.novocode/junit-interface
    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
