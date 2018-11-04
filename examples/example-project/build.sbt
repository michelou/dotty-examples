lazy val root = (project in file(".")).
  settings(
    name := "Hello",
    description := "Hello example",
    version := "0.1",

    scalaVersion := "0.10.0-RC1",
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    ),
    mainClass in Compile := Some("hello.Hello"),
    logLevel := Level.Warn,
    libraryDependencies += ("org.scala-lang.modules" %% "scala-xml" % "1.0.6").withDottyCompat(scalaVersion.value)
  )
