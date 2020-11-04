// val dottyVersion = "3.0.0-M1"
val dottyVersion = "3.0.0-M1-bin-20201027-b5a1715-NIGHTLY"
// val dottyVersion = dottyLatestNightlyBuild.get 

lazy val root = project
  .in(file("."))
  .settings(
    name := "Hello World",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",
    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8"
    ),
    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
