package myexamples

import org.apiguardian.api.API.Status

import org.junit.jupiter.api.Assertions

object Main {
  def main(args: Array[String]): Unit = {
    Assertions.assertTrue(args.length > 0)
    println("Got one or more arguments")
  }
}
