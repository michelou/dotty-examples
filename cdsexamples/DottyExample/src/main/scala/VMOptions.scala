package cdsexamples

import java.lang.management.ManagementFactory
import java.lang.management.RuntimeMXBean

import scala.jdk.CollectionConverters._
import scala.language.implicitConversions

object VMOptions {

  def get: List[String] = {
    val runtimeMxBean = ManagementFactory.getRuntimeMXBean()
    runtimeMxBean.getInputArguments().asScala.toList
  }

  private val sep = System.lineSeparator()+"   "
  def asString: String = "VM Options:"+sep+String.join(sep, VMOptions.get: _*)

}
