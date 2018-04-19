
lazy val root = (project in file("."))
  .settings(
    name := "Hello",
    scalaVersion := sys.props("plugin.scalaVersion"),
    mainClass in Compile := Some("hello"),
    logLevel := Level.Warn,
    libraryDependencies += ("org.scala-lang.modules" %% "scala-xml" % "1.0.6").withDottyCompat()
  )
