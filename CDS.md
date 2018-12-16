# <span id="top">Data Sharing and Dotty on Windows</span> (*Work in progress*)

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This page presents findings from my experiments with <a href="https://docs.oracle.com/javase/8/docs/technotes/guides/vm/class-data-sharing.html">Java class data sharing</a> (CDS) and <a href="http://dotty.epfl.ch/">Dotty</a> on the Windows platform. CDS helps reduce the startup time for Java programming language applications, in particular smaller applications, as well as reduce footprint.
  </td>
  </tr>
</table>

<div style="margin:10px 0; padding:0 0 0 6px;border-top:2px dotted #ff9999;border-bottom:2px dotted #ff9999;color:#999999;">
<div>This page is part of a series of topics related to <a href="http://dotty.epfl.ch/">Dotty</a> on Windows:</div>
<ul style="padding:0p;margin:0;">
<li><a href="README.md">Running Dotty on Windows</a></li>
<li><a href="DRONE.md">Building Dotty on Windows</a></li>
<li>Data Sharing and Dotty on Windows</li>
</ul>
</div>

## Foreword

[Scala 2.12](https://www.scala-lang.org/download/) is a software product announced to require Java 8; in contrast [Dotty](http://dotty.epfl.ch/) (aka. Scala 3) is still in development and will support Java 9+, in particular [Java 11](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html) (2<sup>nd</sup> LTS version after Java 8).

## Project dependencies

This project depends on two external software for the **Microsoft Windows** platform:

- [Oracle Java 11 SDK](https://docs.oracle.com/en/java/javase/11/) ([*release notes*](https://www.oracle.com/technetwork/java/javase/11-0-1-relnotes-5032023.html))
- [Dotty 0.11](https://github.com/lampepfl/dotty/releases) (Java 9+ supported since 0.10)


## Batch command

The [**`sharedata`**](bin/sharedata.bat) batch command:

<pre style="font-size:80%;">
&gt; sharedata help
Usage: sharedata { options | subcommands }
  Options:
    -verbose         display generation progress
    -share[:on|off]  set the share flag (default:off)
  Subcommands:
    activate         install the Java shared archive
    dump             create the Java shared archive
    help             display this help message
    reset            uninstall the Java share archive
    test             execute test application (depends on dump)
</pre>

## Session examples

<pre style="font-size:80%;">
&gt; sharedata activate
Create class list file for Scala compiler
Create Java shared archive for Scala compiler
[...]
Number of classes 3609
[...]
Create class list file for Scala REPL
[...]
Create Java shared archive for Scala REPL
[...]
Number of classes 1586
[...]
Execute test application with Scala REPL WITHOUT Java shared archive
Support files for Java class sharing:
   dotty-cds-compiler.classlist (158 Kb)
   dotty-cds-compiler.jsa (60864 Kb)
   dotty-cds-repl.classlist (70 Kb)
   dotty-cds-repl.jsa (23872 Kb)
   dotty-cds.jar (3 Kb)
   dotty-cds_0.11-0.11.0-RC1.jar (3 Kb)
</pre>

<pre style="font-size:80%;">
&gt; dir /b c:\opt\dotty-0.11.0-RC1\lib\dotty-cds*
dotty-cds-compiler.classlist
dotty-cds-compiler.jsa
dotty-cds-repl.classlist
dotty-cds-repl.jsa
dotty-cds_0.11-0.11.0-RC1.jar
</pre>

<pre style="font-size:80%;">
<b style="color:blue;">object</b> Main {
  def main(args: Array[String]): Unit = {
    println("Support files for Java class sharing:")
    val cdsUrl = getClass().getProtectionDomain().getCodeSource().getLocation()
    val libDir = java.nio.file.Paths.get(cdsUrl.toURI()).getParent().toFile()
    val files = libDir.listFiles.filter(_.getName.startsWith("%_CDS_NAME%"))
    files.foreach(f =^^^> println("   "+f.getName()+" ("+(f.length()/1024)+" Kb)"))
  }
}
</pre>

<pre style="font-size:80%;">
&gt; sharedata test
Execute test application with Scala REPL WITHOUT Java shared archive
Support files for Java class sharing:
   dotty-cds-compiler.classlist (158 Kb)
   dotty-cds-compiler.jsa (60864 Kb)
   dotty-cds-repl.classlist (70 Kb)
   dotty-cds-repl.jsa (23872 Kb)
   dotty-cds_0.11-0.11.0-RC1.jar (3 Kb)
</pre>

<pre style="font-size:80%;">
&gt; sharedata -verbose test
Execute test application with Scala REPL WITHOUT Java shared archive
Support files for Java class sharing:
   dotty-cds-compiler.classlist (158 Kb)
   dotty-cds-compiler.jsa (60864 Kb)
   dotty-cds-repl.classlist (70 Kb)
   dotty-cds-repl.jsa (23872 Kb)
   dotty-cds_0.11-0.11.0-RC1.jar (3 Kb)
Statistics of shared vs. source classes
Shared classes: 0, file/jrt classes: 944
(see W:\dotty\data-sharing\logs\dotty-cds-repl-share.log)
</pre>

<pre style="font-size:80%;">
> sharedata -verbose -share test
Execute test application with Scala REPL WITH Java shared archive
Support files for Java class sharing:
   dotty-cds-compiler.classlist (158 Kb)
   dotty-cds-compiler.jsa (60864 Kb)
   dotty-cds-repl.classlist (70 Kb)
   dotty-cds-repl.jsa (23872 Kb)
   dotty-cds_0.11-0.11.0-RC1.jar (3 Kb)
Statistics of shared vs. source classes
Shared classes: 942, file/jrt classes: 3
(see C:\Users\michelou\WORKSP~1\DOTTY-~1\data-sharing\logs\dotty-cds-repl-share.log)
</pre>

## Bug reports

[JDK-8215398](https://bugs.java.com/bugdatabase/view_bug.do?bug_id=JDK-8215398)
***

*[mics](http://lampwww.epfl.ch/~michelou/)/December 2018* [**&#9650;**](#top)
