val dottyVersion = "0.20.0-RC1"

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

    libraryDependencies ++= Seq(
      //https://mvnrepository.com/artifact/org.scala-lang.modules/scala-xml_2.13
      "org.scala-lang.modules" %% "scala-xml" % "1.2.0").withDottyCompat(scalaVersion.value
    )
  )
