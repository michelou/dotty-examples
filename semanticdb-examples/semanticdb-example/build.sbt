ThisBuild / version := "2.13.6"

commands += Command.command("runExample") { s =>
  val dir = classDirectory.in(example, Compile).value
  "example/compile" ::
    s"cli/run $dir" ::
    s
}

lazy val example = project
  .settings(
    addCompilerPlugin(
      "org.scalameta" % "semanticdb-scalac" % "4.4.28" cross CrossVersion.full),
    scalacOptions += "-Yrangepos"
  )

lazy val cli = project
  .settings(
    libraryDependencies += "org.scalameta" %% "scalameta" % "4.4.28"
  )
