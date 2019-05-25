import mill._, scalalib._

object go extends ScalaModule {
  def scalaVersion = "0.15.0-RC1"  // "2.12.18"
  def scalacOptions = Seq("-deprecation", "-feature")
  def forkArgs = Seq("-Xmx1g")
  def mainClass = Some("Test")
  def sources = T.sources { os.pwd / "src" }
  def clean() = T.command {
    val path = os.pwd / "out" / "go"
    os.walk(path, skip = _.last == "clean").foreach(os.remove.all)
  }
}
