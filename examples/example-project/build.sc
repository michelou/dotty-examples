import mill._, scalalib._

object go extends ScalaModule {
  def scalaVersion = "0.13.0-RC1"  // "2.12.18"
  def scalacOptions = Seq("-deprecation", "-feature")
  def forkArgs = Seq("-Xmx1g")
  def mainClass = Some("hello.Hello")
  def sources = T.sources { os.pwd / 'src }
}
