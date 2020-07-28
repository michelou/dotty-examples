# <span id="top">Dotty plugin examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:100px;" src="../docs/dotty.png" width="100" alt="Dotty logo"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>plugin-examples\</code></strong> contains <a href="https://dotty.epfl.ch/" rel="external" title="Dotty">Dotty</a> code examples written by myself.
  </td>
  </tr>
</table>

## <span id="dividezero">DivideZero</span>

Command [**`build clean test`**](DivideZero/build.bat) generates the [Dotty] plugin **`DivideZero.jar`** and executes the test [`DivideZeroTest`](DivideZero/src/test/scala/DivideZero.scala):

<pre style="font-size:80%;">
<b>&gt; <a href="DivideZero/build.bat">build</a> clean test</b>
-- Error: W:\plugin-examples\DivideZero\src\test\scala\DivideZeroTest.scala:6:12
6 |    println(a / zero)  // error: divide by zero
  |            ^^^^^^^^
  |            divide by zero
-- Error: W:\plugin-examples\DivideZero\src\test\scala\DivideZeroTest.scala:14:12
14 |    println(i / zero)  // error: divide by zero
   |            ^^^^^^^^
   |            divide by zero
-- Error: W:\plugin-examples\DivideZero\src\test\scala\DivideZeroTest.scala:15:12
15 |    println(l / 0)     // error: divide by zero
   |            ^^^^^
   |            divide by zero
-- Error: W:\plugin-examples\DivideZero\src\test\scala\DivideZeroTest.scala:16:12
16 |    println(s / 0)     // error: divide by zero
   |            ^^^^^
   |            divide by zero
-- Error: W:\plugin-examples\DivideZero\src\test\scala\DivideZeroTest.scala:17:12
17 |    println(f / 0)     // error: divide by zero
   |            ^^^^^
   |            divide by zero
-- Error: W:\plugin-examples\DivideZero\src\test\scala\DivideZeroTest.scala:18:12
18 |    println(d / 0)     // error: divide by zero
   |            ^^^^^
   |            divide by zero
-- Error: W:\plugin-examples\DivideZero\src\test\scala\DivideZeroTest.scala:21:12
21 |    println(x / 0)     // error: divide by zero
   |            ^^^^^
   |            divide by zero
-- Error: W:\plugin-examples\DivideZero\src\test\scala\DivideZeroTest.scala:22:12
22 |    println(x / 0.0)   // error: divide by zero
   |            ^^^^^^^
   |            divide by zero
8 errors found
Error: Compilation of test Scala source files failed
</pre>


## <span id="modifypipeline">ModifyPipeline</span>

Command [**`build clean test`**](ModifyPipeline/build.bat) generates the [Dotty] plugin **`ModifyPipeline.jar`** and executes the test [`ModifyPipelineTest`](ModifyPipeline/src/test/scala/ModifyPipelineTest.scala):

<pre style="font-size:80%;">
<b>&gt; <a href="DivModifyPipelineideZero/build.bat">build</a> clean test</b>
5
5
</pre>


## <span id="multiplyone">MultiplyOne</span>

Command [**`build clean test`**](MultiplyOne/build.bat) generates the [Dotty] plugin **`MultiplyOne.jar`** and executes the test [`MultiplyOneTest`](MultiplyOne/src/test/scala/MultiplyOneTest.scala):

<pre style="font-size:80%;">
<b>&gt; <a href="MultiplyOne/build.bat">build</a> clean test</b>
5
5
25
25
1.4142135623730951
1.4142135623730951
a
aaaaaaaaaa
</pre>


***

*[mics](https://lampwww.epfl.ch/~michelou/)/July 2020* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[dotty]: https://dotty.epfl.ch/
