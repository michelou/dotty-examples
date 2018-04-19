
lazy val root = (project in file("."))
  .settings(
    name := "Hello",
    scalaVersion := "2.12.5",
    mainClass in Compile := Some("hello"),
    logLevel := Level.Warn
  )
