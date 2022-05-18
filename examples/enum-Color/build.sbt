val scala3Version = "3.1.3-RC2" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "enum-Color",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    ),
    // resolvers += "Maven Central Server" at "http://central.maven.org/maven2",
    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/com.novocode/junit-interface
      "com.novocode" % "junit-interface" % "0.11" % Test,
      // https://mvnrepository.com/artifact/org.scalacheck/scalacheck
      "org.scalacheck" %% "scalacheck" % "1.16.0" % Test,
      // https://mvnrepository.com/artifact/org.scalatest/scalatest
      "org.scalatest" %% "scalatest" % "3.2.12" % Test
    ),
    testOptions ++= Seq(
      Tests.Setup(() => println("Setup JUnit tests")),
      Tests.Cleanup(() => println("Cleanup JUnit tests")),
      Tests.Filter(s => s.endsWith("Test"))
    ),
    // receive periodic notifications of tests that have been running longer than 120 seconds
    Test / testOptions += Tests
      .Argument(TestFrameworks.ScalaTest, "-W", "120", "60")
  )
