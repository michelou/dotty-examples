val scala3Version = "3.3.5" // = dottyLatestNightlyBuild.get 

lazy val root = project
  .in(file("."))
  .settings(
    name := "s-99",
    description := "sbt example project to build/run Scala 3 applications",
    organization := "Stéphane Micheloud",
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
      // https://mvnrepository.com/artifact/com.github.sbt/junit-interface
      "com.github.sbt" % "junit-interface" % "0.13.3" % Test,
      // https://mvnrepository.com/artifact/org.scalacheck/scalacheck
      "org.scalacheck" % "scalacheck_3" % "1.18.0" % Test,
      // https://mvnrepository.com/artifact/org.scalatest/scalatest
      "org.scalatest" % "scalatest_3" % "3.2.19" % "test"
    ),

    testOptions ++= Seq(
      Tests.Setup(() => println("Setup")),
      Tests.Cleanup(() => println("Cleanup")),
      Tests.Filter(s => s.endsWith("Test"))
    )
  )
