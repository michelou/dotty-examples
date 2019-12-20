import mill._, scalalib._

object go extends ScalaModule {
  def scalaVersion = "0.21.0-RC1"  // "2.12.18"
  def scalacOptions = Seq("-deprecation", "-feature")
  def forkArgs = Seq("-Xmx1g")
  def mainClass = Some("Planet")
  def sources = T.sources { os.pwd / "src" }
  def clean() = T.command {
    val path = os.pwd / "out" / "go"
    os.walk(path, skip = _.last == "clean").foreach(os.remove.all)
  }
  def ivyDeps = Agg(
    ivy"org.junit.platform:junit-platform-commons:1.3.2",
    ivy"org.junit.platform:junit-platform-runner:1.3.2",
    ivy"org.junit.jupiter:junit-jupiter-engine:5.5.2"
  )
}
