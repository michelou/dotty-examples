val scala3Version = "3.2.2-RC2" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "Sudoku",
    description := "see https://blog.rockthejvm.com/sudoku-backtracking/",
    version := "0.1.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature"
    )
  )
