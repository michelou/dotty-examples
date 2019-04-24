import mill._, scalalib._

object go extends ScalaModule {
  def scalaVersion = "0.14.0-RC1"  // "2.12.18"
  def scalacOptions = Seq("-deprecation", "-feature")
  def forkArgs = Seq("-Xmx1g")
  def mainClass = Some("Main")
  def sources = T.sources { os.pwd / "src" }
  def ivyDeps =
    Agg(Dep(org = "junit", name = "junit", version="4.12", CrossVersion.empty(false)))
  def clean() = T.command {
    val path = os.pwd / "out" / "go"
    os.walk(path, skip = _.last == "clean").foreach(os.remove.all)
  }
}
