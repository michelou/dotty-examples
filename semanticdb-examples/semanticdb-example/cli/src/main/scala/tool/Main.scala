package tool

import java.nio.file.Files
import java.nio.file.Paths
// import scala.collection.JavaConverters._ // deprecated since 2.13.0
import scala.jdk.CollectionConverters._
import scala.meta.internal.{semanticdb => s}

object Main {

  def main(args: Array[String]): Unit = args.toList match {
    case path :: Nil =>
      val semanticdbRoot =
        Paths.get(path).resolve("META-INF").resolve("semanticdb")
      val semanticdbFiles = Files
        .walk(semanticdbRoot)
        .iterator()
        .asScala
        .filter(_.getFileName.toString.endsWith(".semanticdb"))
        .toList

      semanticdbFiles.foreach { semanticdbFile =>
        for {
          document <- s.TextDocuments
            .parseFrom(Files.readAllBytes(semanticdbFile))
            .documents
        } {
          pprint.log(document.uri)
          document.occurrences.filter(_.role.isReference).foreach { o =>
            println(o.toProtoString)
          }
        }
      }
    case els =>
      sys.error(s"Expected <path>, obtained $els")
  }

}
