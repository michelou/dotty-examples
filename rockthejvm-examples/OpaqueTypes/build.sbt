val scala3Version = "3.1.2-RC1" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "OpaqueTypes",
    description := "see https://blog.rockthejvm.com/scala-3-opaque/",
    version := "0.1.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    )
  )