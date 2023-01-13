val dottyVersion = "3.2.2"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Higher-Kinded Types",
    description := "Example sbt project that compiles using Scala 3",
    version := "0.1.0",
    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation"
    ),
    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )
