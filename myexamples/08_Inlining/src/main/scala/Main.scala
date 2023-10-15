package foo {

  object A {
    inline def f(x: Int) = B.f(x)
  }

  private[foo] object B {
    def f(x: Int) = x * 5
  }

}

package bar {

  class Test {
    val x = foo.A.f(4)
  }

}

package myexamples {

  object Main {

    def main(args: Array[String]): Unit = {
      println((new bar.Test).x)
    }

  }

}
