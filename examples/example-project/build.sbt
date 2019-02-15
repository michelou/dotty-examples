val dottyVersion = "0.12.0-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Hello",
    description := "Hello example",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    ),

    mainClass in Compile := Some("hello.Hello"),
    logLevel := Level.Warn,

    libraryDependencies += ("org.scala-lang.modules" %% "scala-xml" % "1.0.6").withDottyCompat(scalaVersion.value)
  )
