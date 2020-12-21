val dottyVersion = "3.0.0-M3"
// val dottyVersion = dottyLatestNightlyBuild.get 

lazy val root = project
  .in(file("."))
  .settings(
    name := "Dependent Types",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8"
    ),

    libraryDependencies += "com.novocode" % "junit-interface" % "0.11" % "test"
  )

val createDocsDirectory = taskKey[File]("Create directory target/docs")

lazy val aaa = project
  .in(file("."))
  .settings(
    name := "AAAAAAAAAAAA",
    description := "sbt example project to build/run Scala 3 applications",
    version := "1.0.0",

    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-project", "AAAAA",
      "-siteroot "+createDocsDirectory.value
    ),

    createDocsDirectory := {
      val docsDir = baseDirectory.value / "target" / "docs"
      if (!docsDir.exists) IO.createDirectory(docsDir)
      docsDir
    }
  )
