val scala3Version = "3.3.0-RC3"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Intersection Types",
    description := "sbt example project to build/run Scala 3 applications",
    version := "0.1.0",

    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    ),

    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/com.novocode/junit-interface
      "com.novocode" % "junit-interface" % "0.11" % "test"
    )
  )
