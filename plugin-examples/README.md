# <span id="top">Scala 3 plugin examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:100px;" src="../docs/dotty.png" width="100" alt="Scala 3 logo"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>plugin-examples\</code></strong> contains <a href="https://dotty.epfl.ch/" rel="external" title="Scala 3">Scala 3</a> code examples written by myself.
  </td>
  </tr>
</table>

We present how to write/execute [Scala 3][scala3] plugins in the following code examples:

- [**`DivideZero`**](#dividezero) generates an error message when the plugin detects a division by zero.
- [**`ModifyPipeline`**](#modifypipeline)
- [**`MultiplyOne`**](#multiplyone) removes a multiply operation when the plugin detects that one of the operands is `1`.

> **:mag_right:** As a reminder we have to perform two compilation tasks for each example:
> 1. compilation of the *plugin source files* (e.g. `target\DivideZero.jar`)
> 2. compilation ot the *test source files* with the plugin enabled/disabled.

## <span id="dividezero">DivideZero</span>

Command [`build`](DivideZero/build.bat) with no parameter displays the help message:

<pre style="font-size:80%;">
<b>&gt; <a href="DivideZero/build.bat">build</a></b>
Usage: build { &lt;option&gt; | &lt;subcommand&gt; }

  Options:
    -debug           show commands executed by this script
    -explain         set compiler option -explain
    -explain-types   set compiler option -explain-types
    -tasty           compile both from source and TASTy files
    -timer           display total elapsed time
    -verbose         display progress messages

  Subcommands:
    clean            delete generated class files
    compile          compile Scala source files
    doc              generate HTML documentation
    help             display this help message
    pack             create Java archive file
    test             execute unit tests
    test:noplugin    execute unit tests with NO plugin
</pre>

First let us try subcommand **`test:noplugin`** to see the output when the plugin is disabled for the test:

<pre style="font-size:80%;">
<b>&gt; <a href="DivideZero/build.bat">build</a> clean test:noplugin</b>
Exception in thread "main" java.lang.ArithmeticException: / by zero
        at DivideZeroTest$.main(DivideZeroTest.scala:6)
        at DivideZeroTest.main(DivideZeroTest.scala)
</pre>

Command [**`build test`**](DivideZero/build.bat) generates the [Scala 3][scala3] plugin **`DivideZero.jar`** from source file [**`DivideZero.scala`**](DivideZero/src/main/scala/DivideZero.scala) and tests the plugin with source file [**`DivideZeroTest.scala`**](DivideZero/src/test/scala/DivideZeroTest.scala):

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

> **:mag_right:** We give two argument files to the [Scala 3][scala3] compiler: **`target\test_scalac_opts.txt`** (compiler options) and **`target\test_scalac_sources.txt`** (source files):
> &nbsp;
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/type" rel="external">type</a> target\test_scala*.txt</b>
> &nbsp;
> target\test_scalac_opts.txt
> &nbsp;
> &nbsp;
>-deprecation -feature -nowarn -Xplugin:"W:\plugin-examples\DivideZero\target\divideZero.jar" -Xplugin-require:divideZero -P:"divideZero:opt1=1" -classpath "W:\plugin-examples\DivideZero\target\classes;W:\plugin-examples\DivideZero\target\test-classes" -d "W:\plugin-examples\DivideZero\target\test-classes"
> &nbsp;
> target\test_scalac_sources.txt
> &nbsp;
> &nbsp;
> W:\plugin-examples\DivideZero\src\test\scala\DivideZeroTest.scala
> </pre>
> In particular we observe the usage of the two plugin options **`-Xplugin:<plugin_jar_file>`** and **`-Xplugin-require:<plugin_name> -P:"divideZero:opt1=1"`**.

## <span id="modifypipeline">ModifyPipeline</span>

Command [**`build test`**](ModifyPipeline/build.bat) generates the [Scala 3][scala3] plugin **`ModifyPipeline.jar`** from source file [**`ModifyPipeline.scala`**](ModifyPipeline/src/main/scala/ModifyPipeline.scala) and tests the plugin with source file [**`ModifyPipelineTest.scala`**](ModifyPipeline/src/test/scala/ModifyPipelineTest.scala):

<pre style="font-size:80%;">
<b>&gt; <a href="ModifyPipeline/build.bat">build</a> clean test</b>
5
5
</pre>


## <span id="multiplyone">MultiplyOne</span>

Command [**`build clean test`**](MultiplyOne/build.bat) generates the [Scala 3][scala3] plugin **`MultiplyOne.jar`** from source file [**`MultiplyOne.scala`**](MultiplyOne/src/main/scala/MultiplyOne.scala) and tests the plugin with source file [**`MultiplyOneTest.scala`**](MultiplyOne/src/test/scala/MultiplyOneTest.scala):

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

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[scala3]: https://dotty.epfl.ch/
