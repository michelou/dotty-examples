val scala3Version = "3.1.2-RC1"
val akkaHttpVersion = "10.2.9"
val sparkVersion = "3.2.1"
val twitter4jVersion = "4.0.7"
val kafkaVersion = "3.1.0"

lazy val root = project
  .in(file("."))
  .settings(
    name := "Type-Level_Programming_1",
    description := "Type-level programming, part 1",
    version := "0.1.0",
    scalaVersion := scala3Version,
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding", "UTF-8",
      "-feature"
    ),
    // resolvers += "Maven Central Server" at "http://central.maven.org/maven2",
    libraryDependencies ++= Seq(
      // https://mvnrepository.com/artifact/com.typesafe.akka/akka-http
      "com.typesafe.akka" % "akka-http_2.13" % akkaHttpVersion,
      "com.typesafe.akka" % "akka-http-spray-json_2.13" % akkaHttpVersion,

      // https://mvnrepository.com/artifact/org.apache.spark/spark-core
      "org.apache.spark" % "spark-core_2.13" % sparkVersion,
      "org.apache.spark" % "spark-sql_2.13" % sparkVersion,
      "org.apache.spark" % "spark-streaming_2.13" % sparkVersion,

      // https://mvnrepository.com/artifact/org.apache.logging.log4j/log4j-api
      "org.apache.logging.log4j" % "log4j-api" % "2.13.3",
      "org.apache.logging.log4j" % "log4j-core" % "2.13.3",

      // https://mvnrepository.com/artifact/org.twitter4j/twitter4j-core
      "org.twitter4j" % "twitter4j-core" % twitter4jVersion,
      "org.twitter4j" % "twitter4j-stream" % twitter4jVersion,

      // https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-s3
      "com.amazonaws" % "aws-java-sdk-s3" % "1.12.171",

      // https://mvnrepository.com/artifact/org.apache.kafka/kafka
      "org.apache.kafka" % "kafka_2.13" % kafkaVersion,
      "org.apache.kafka" % "kafka-streams" % kafkaVersion,

      "org.scala-lang" % "scala-library" % "2.13.8",
      "org.scala-lang" % "scala-reflect" % "2.13.8"
    )
  )
