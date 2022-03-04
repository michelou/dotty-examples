// adapted from https://blog.rockthejvm.com/new-types-scala-3/
package rockthejvm

import java.io.File

@main def Main: Unit =

  // 1 - literal types
  val aNumber = 1
  val three: 3 = 3 // 3 <: Int
  
  def passNumber(n: Int) = println(n)
  def passStrict(n: 3) = println(n)

  val pi : 3.14 = 3.14
  val truth: true = true
  val myFavoriteLanguage: "Scala" = "Scala"

  passNumber(45)
  passNumber(three)  // ok
  passNumber(-10)

  // passStrict(45) // not ok
  passStrict(three)
  // passStrict(-10) // not ok

  // 2 - union types
  def ambivalentMethod(arg: String | Int) = arg match {
    case _: String => println(s"a string: $arg")
    case _: Int    => println(s"an int  : $arg")
  }

  ambivalentMethod(42)
  ambivalentMethod("Scala")
  
  type ErrorOr[T] = T | "error"
  def handleResource(file: ErrorOr[File]): Unit = {
    // your code here
  }

  val stringOrInt = if (43 > 0) "a string" else 41
  val aStringOrInt: String | Int = if (43 > 0) "a string" else 41

  // 3 - intersection types
  trait Camera {
    def makePhoto() = println("snap")
  }

  trait Phone {
    def makeCall() = println("ring")
  }
  
  def userSmartDevice(sp: Camera & Phone): Unit = {
    sp.makePhoto()
    sp.makeCall()
  }

  class SmartPhone extends Camera, Phone

  userSmartDevice(new SmartPhone)
  userSmartDevice(new Camera with Phone)
