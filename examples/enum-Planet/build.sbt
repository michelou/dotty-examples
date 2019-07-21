val dottyVersion = "0.16.0-RC3"

lazy val root = project
  .in(file("."))
  .settings(
    name := "enum-Planet",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-feature"
    ),

    // resolvers += "Maven Central Server" at "http://central.maven.org/maven2",

    // https://mvnrepository.com/artifact/com.novocode/junit-interface
    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % Test,
    // https://mvnrepository.com/artifact/org.scalacheck/scalacheck
    libraryDependencies += "org.scalacheck" % "scalacheck_2.12" % "1.14.0" % Test,

    testOptions ++= Seq(
      Tests.Setup(() => println("Setup")),
      Tests.Cleanup(() => println("Cleanup")),
      Tests.Filter(s => s.endsWith("Test"))
    )
  )
