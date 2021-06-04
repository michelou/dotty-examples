val dottyVersion = "3.0.1-RC1"
// val dottyVersion = dottyLatestNightlyBuild.get 

lazy val root = project
  .in(file("."))
  .settings(
    name := "Hello",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    ),

    Compile / mainClass := Some("hello.Hello"),
    logLevel := Level.Warn,

    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/org.scala-lang.modules/scala-xml_2.13
      "org.scala-lang.modules" %% "scala-xml" % "2.0.0-RC1"
    ) //.withDottyCompat(scalaVersion.value)
  )
