# <span id="top">SemanticDB examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://scalameta.org/docs/semanticdb/guide.html/" rel="external"><img style="border:0;width:120px;" src="https://scalameta.org/img/scalameta.png" alt="Dotty project" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>semanticdb-examples\</code></strong> contains <a href="https://scalameta.org/docs/semanticdb/guide.html" rel="external">SemanticDB</a> code examples coming from various websites - mostly from the <a href="https://scalameta.org/docs/semanticdb/guide.html" rel="external">SemanticDB project</a>.
  </td>
  </tr>
</table>

> **:mag_right:** We need to install additional command-line tools in order to work on our code examples.
> - [Metac] - generate `.semanticdb` files.
> - [Metap] - prettyprint `.semanticdb` files.
> - [Protoc] - compile `.proto` files.
> 
> We proceed in two ways to install the above tools:
> - We rely on [Coursier] to install the tools **`metac`** and **`metap`** <sup id="anchor_01">[[1]](#footnote_01)</sup>.
> - We extract the Zip archive `protoc-3.yy.z-win64.zip` (available from the GitHub project [`protocolbuffers/protobuf`](https://github.com/protocolbuffers/protobuf/releases)) into directory **`C:\opt\protoc-3.yy.z\`**.
> 
> Finally we modify the environment variable `PATH` in our current session as follows:
> <pre style="font-style:80%;">
> <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a> "PATH=%PATH%;%COURSIER_DATA_DIR%\bin;c:\opt\protoc-3.18.1"
> </pre>

## <span id="hello">`hello`</span>

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where">where</a> metac</b>
<a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%LOCALAPPDATA%</a>\Coursier\data\bin\metac.bat
&nbsp;
<b>&gt; <a href="https://scalameta.org/docs/semanticdb/guide.html#metac">metac</a> -d target\classes src\main\scala\Main.scala</b>
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f target\classes |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /b /v [a-z]</b>
│   .latest-build
│
└───META-INF
    └───semanticdb
        └───src
            └───main
                └───scala
                        Main.scala.semanticdb
</pre>

By default command **`metap <classpath>`** prints only the most important parts of the SemanticDB payload (default option is **`-compact`**).

<pre style="font-size:80%;">
<b>&gt; <a href="https://scalameta.org/docs/semanticdb/guide.html#metap">metap</a> target\classes</b>
src/main/scala/Main.scala
&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;&minus;
&nbsp;
Summary:
Schema =&gt; SemanticDB v4
Uri =&gt; src/main/scala/Main.scala
Text =&gt; empty
Language =&gt; Scala
Symbols =&gt; 3 entries
Occurrences =&gt; 7 entries
&nbsp;
Symbols:
_empty_/Main. =&gt; final object Main extends AnyRef { +1 decls }
_empty_/Main.main(). =&gt; method main(args: Array[String]): Unit
_empty_/Main.main().(args) =&gt; param args: Array[String]

Occurrences:
[0:7..0:11) &lt;= _empty_/Main.
[1:6..1:10) &lt;= _empty_/Main.main().
[1:11..1:15) &lt;= _empty_/Main.main().(args)
[1:17..1:22) =&gt; scala/Array#
[1:23..1:29) =&gt; scala/Predef.String#
[1:33..1:37) =&gt; scala/Unit#
[2:4..2:11) =&gt; scala/Predef.println(+1).
</pre>

## <span id="semanticdb-example">`semanticdb-example`</span>

This code example is an updated version of Geirsson's example (May 2018) available from his GitHub project [`olafurpg/semantic-example`](https://github.com/olafurpg/semanticdb-example).

This example is interesting because we programmatically access the generated `.semanticdb` files from the main program [`Main.scala`](semanticdb-example/cli/src/main/scala/tool/Main.scala).

<pre style"=font-size:80%;">
<b>&gt; <a href="semanticdb-example/build.bat">build</a> -verbose compile</b>
Generate SemanticDB data for 2 Scala source files into directory "example\target\classes"
Compile 1 Scala source file to directory "cli\target\classes"
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /f example\target\classes |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /b /v [a-z]</b>
└───META-INF
    └───semanticdb
        └───example
            └───src
                └───main
                    └───scala
                        └───example
                                Domain.scala.semanticdb
                                Example.scala.semanticdb
</pre>

Then we execute the main program and redirect the output to some file, e.g. `output.txt`:

<pre style="font-size:80%;">
<b>&gt; <a href="semanticdb-example/build.bat">build</a> -verbose run > output.txt</b>
No action required ('example\src\main\scala\*.scala')
No action required ('cli\src\main\scala\*.scala')
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/more">more</a> output.txt</b>
W:\semanticdb-examples\semanticdb-example\cli\src\main\scala\tool\Main.scala:28 document.uri: "example/src/main/scala/example/Domain.scala"
range {
  start_line: 8
  start_character: 27
  end_line: 8
  end_character: 33
}
symbol: "scala/Predef.String#"
role: REFERENCE
[...]
range {
  start_line: 8
  start_character: 57
</pre>

## <span id="footnotes">Footnotes</span>

<span name="footnote_01">[1]</span> ***Installation with Coursier*** [↩](#anchor_01)

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where">where</a> cs</b>
C:\opt\coursier-2.0.16\cs.exe
&nbsp;
<b>&gt; <a href="https://get-coursier.io/docs/cli-overview">cs</a> install metac metap</b>
https://repo1.maven.org/maven2/io/get-coursier/apps/maven-metadata.xml
  100.0% [##########] 2.0 KiB (18.6 KiB / s)
[...]
https://repo1.maven.org/maven2/org/scalameta/semanticdb-scalac_2.13.6/4.4.28/semanticdb-scalac_2.13.6-4.4.28.jar
  100.0% [##########] 14.6 MiB (1.2 MiB / s)
Wrote metac
[...]
https://repo1.maven.org/maven2/com/thesamet/scalapb/scalapb-runtime_2.13/0.11.4/scalapb-runtime_2.13-0.11.4.jar
  100.0% [##########] 2.3 MiB (1.1 MiB / s)
Wrote metap
Warning: <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%LOCALAPPDATA%</a>\Coursier\data\bin is not in your PATH
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/October 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[coursier]: https://get-coursier.io/
[metac]: https://scalameta.org/docs/semanticdb/guide.html#metac
[metap]: https://scalameta.org/docs/semanticdb/guide.html#metap
[protoc]: https://github.com/protocolbuffers/protobuf/releases