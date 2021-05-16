val dottyVersion = "3.0.0"
// val dottyVersion = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "Value Types",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0-0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    ),

    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
