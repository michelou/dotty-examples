val scala3Version = "3.0.1-RC2" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "TypeLambdas",
    description := "see https://blog.rockthejvm.com/scala-3-type-lambdas/",
    version := "0.1.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    )
  )
