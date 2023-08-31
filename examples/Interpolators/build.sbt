val dottyVersion = "3.3.1-RC7"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Interpolators",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    ),

    Compile / mainClass := Some("Main"),
    logLevel := Level.Warn,

    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/org.scala-lang.modules/scala-xml
      "org.scala-lang.modules" %% "scala-xml" % "2.2.0"
    ) //.withDottyCompat(scalaVersion.value)
  )
