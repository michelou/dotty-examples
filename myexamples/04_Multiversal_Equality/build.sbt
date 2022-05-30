val scala3Version = "3.1.3-RC4" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "Multiversal Equality",
    description := "sbt example project to build/run Scala 3 applications",
    version := "0.1.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    ),
    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
