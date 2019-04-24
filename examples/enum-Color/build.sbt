val dottyVersion = "0.14.0-RC1"

lazy val root = project
  .in(file("."))
  .settings(
    name := "enum-Color",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-feature"
    ),

    // resolvers += "Maven Central Server" at "http://central.maven.org/maven2",

    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/com.novocode/junit-interface
      "com.novocode" % "junit-interface" % "0.11" % Test,
      // https://mvnrepository.com/artifact/org.scalacheck/scalacheck
      "org.scalacheck" % "scalacheck_2.12" % "1.14.0" % Test,
      // https://mvnrepository.com/artifact/org.scalatest/scalatest
      "org.scalatest" % "scalatest_2.12" % "3.0.6" % "test"
    ),

    testOptions ++= Seq(
      Tests.Setup(() => println("Setup JUnit tests")),
      Tests.Cleanup(() => println("Cleanup JUnit tests")),
      Tests.Filter(s => s.endsWith("Test"))
    ),

    // receive periodic notifications of tests that have been running longer than 120 seconds
	testOptions in Test += Tests.Argument(TestFrameworks.ScalaTest, "-W", "120", "60")
  )
