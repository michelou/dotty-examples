val scala3Version = "3.3.4-RC1" // = dottyLatestNightlyBuild.get

lazy val root = project
  .in(file("."))
  .settings(
    name := "Dependent Types",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8"
    ),
    // https://mvnrepository.com/artifact/com.github.sbt/junit-interface
    libraryDependencies += "com.github.sbt" % "junit-interface" % "0.13.3" % "test"
  )

val createDocsDirectory = taskKey[File]("Create directory target/docs")

lazy val aaa = project
  .in(file("."))
  .settings(
    name := "Dependent Types",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-project",
      name.toString,
      "-siteroot " + createDocsDirectory.value
    ),
    createDocsDirectory := {
      val docsDir = baseDirectory.value / "target" / "docs"
      if (!docsDir.exists) IO.createDirectory(docsDir)
      docsDir
    }
  )
