val scala3Version = "3.3.1-RC7" // = dottyLatestNightlyBuild.get 

lazy val root = project
  .in(file("."))
  .settings(
    name := "Extension Methods",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8",
      "-feature"
    ),
    // run / fork := true,
    // javaOptions ++= List("-Xms1024m", "-Xmx1024m", "-XX:ReservedCodeCacheSize=128m", "-Xss2m", "-Dfile.encoding=UTF-8"),
    //
    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/com.novocode/junit-interface
      "com.novocode" % "junit-interface" % "0.11" % "test"
    )
  )
