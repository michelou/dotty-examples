# <span id="top">Data Sharing and Dotty on Windows</span> (*work-in-progress*)

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This page presents findings from my experiments with <a href="https://docs.oracle.com/javase/8/docs/technotes/guides/vm/class-data-sharing.html">Java class data sharing</a> (CDS) and <a href="http://dotty.epfl.ch/">Dotty</a> on the Windows platform. CDS helps reduce the startup time for Java applications, in particular smaller applications, as well as reduce memory footprint.
  </td>
  </tr>
</table>

This page is part of a series of topics related to [Dotty](http://dotty.epfl.ch/) on Windows:

- [Running Dotty on Windows](README.md)
- [Building Dotty on Windows](DRONE.md)
- Data Sharing and Dotty on Windows


> **:mag_right:**
> [Scala 2.12](https://www.scala-lang.org/download/) is a software product announced to require Java 8; in contrast [Dotty](http://dotty.epfl.ch/) (aka [Scala 3.0](https://www.scala-lang.org/blog/2018/04/19/scala-3.html)) is still in development and will support Java 9+, in particular [Java 11](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html) (2<sup>nd</sup> LTS version after Java 8).

## Project dependencies

This project depends on two external software for the **Microsoft Windows** platform:

- [Oracle Java 11 SDK](https://docs.oracle.com/en/java/javase/11/) ([*release notes*](https://www.oracle.com/technetwork/java/javase/11-0-1-relnotes-5032023.html))
- [Dotty 0.11](https://github.com/lampepfl/dotty/releases) (Java 9+ supported since 0.10)

## Overview

- Section **Java Example** present a Java demo application.
- In section **Dotty Example** we move to [Dotty](http://dotty.epfl.ch/) with the same application written in Dotty.
- Finally we describe the batch command **`sharedata.bat`**.

> **:warning:** We have submitted a bug report related to the usage of option **`-Xlog`** on Windows (see [JDK-8215398](https://bugs.java.com/bugdatabase/view_bug.do?bug_id=JDK-8215398)): 

## Java Example

We added an option **`-share`** to the batch command [**`build`**](cdsexamples/HelloWorld_Java/build.bat) in the Java demo applicatin. Internally we generate a Java shared archive as last step of the compilation phase (**`target\HelloWorld.jsa`**):

<pre style="font-size:80%;">
> build help
Usage: build { options | subcommands }
  Options:
    -share[:(on|off)]  enable/disable data sharing (default:off)
    -verbose          display progress messages
  Subcommands:
    clean             delete generated files
    compile           compile Java source files
    help              display this help message
    run               execute main class
</pre>

<pre style="font-size:80%;">
&gt; build -verbose clean compile
Create Java archive target\HelloWorld.jar
Create class list file target\HelloWorld.classlist
Create Java shared archive target\HelloWorld.jsa
</pre>

Let's check the contents of the **`target\`** output directory:

<pre style="font-size:80%;">
&gt; tree /a /f target |findstr /v "^[A-Z]"
|   HelloWorld.classlist
|   HelloWorld.jar
|   HelloWorld.jsa
|   MANIFEST.MF
|
+---classes
|   |   .latest-build
|   |
|   \---cdsexamples
|           HelloWorld.class
|
\---logs
        log_classlist.log
        log_dump.log
</pre>

We can now execute our Java example ***with data sharing*** (default settings: **`-share:off`**):

<pre style="font-size:80%;">
&gt; build -verbose run -share
Hello world !
Statistics (see details in target\logs\log_share_on.log):
   Share flag      : on
   Shared classes  : 516
   File/jrt classes: 1
   Load time       : 0.113s
</pre>

For comparison here is the output ***without data sharing***:

<pre style="font-size:80%;">
&gt; build -verbose run
Hello world !
Statistics (see details in target\logs\log_share_off.log):
   Share flag      : off
   Shared classes  : 0
   File/jrt classes: 594
   Load time       : 0.150s
</pre>

Command **`java.exe -Xshare:dump`** uses file **`lib\classlist`** to generate the Java shared archive **`bin\server\classes.jsa`** (17.3 Mb).
<pre style="font-size:80%;">
&gt; java -version 2>&1 | findstr version
openjdk version "11.0.1" 2018-10-16

&gt; java -Xshare:dump
[...]
Number of classes 1272
[...]
mc  space:      8416 [  0.0% of total] [...]
rw  space:   4022728 [ 22.2% of total] [...]
ro  space:   7304712 [ 40.4% of total] [...]
md  space:      2560 [  0.0% of total] [...]
od  space:   6534368 [ 36.1% of total] [...]
total    :  17872784 [100.0% of total] [...]

&gt; dir /b c:\opt\jdk-11.0.1\bin\server
classes.jsa
jvm.dll
</pre>

## Dotty Example

We added an option **`-share`** to the batch command [**`build`**](cdsexamples/HelloWorld/build.bat) in the [Dotty](http://dotty.epfl.ch/) demo applicatin. Internally we generate a Java shared archive as last step of the compilation phase (**`target\HelloWorld.jsa`**):

<pre style="font-size:80%;">
> build help
Usage: build { options | subcommands }
  Options:
    -share[:(on|off)]  enable/disable data sharing (default:off)
    -verbose          display progress messages
  Subcommands:
    clean             delete generated files
    compile           compile Scala source files
    help              display this help message
    run               execute main class
</pre>

## Batch command

The [**`sharedata`**](bin/sharedata.bat) batch command:

<pre style="font-size:80%;">
&gt; sharedata help
Usage: sharedata { options | subcommands }
  Options:
    -share[:(on|off)]  set the share flag (default:off)
    -verbose          display generation progress
  Subcommands:
    activate          install the Java shared archive
    dump              create the Java shared archive
    help              display this help message
    reset             uninstall the Java share archive
    test              execute test application (depends on dump)
</pre>

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
<b>object</b> Main {
  <b>def</b> main(args: Array[String]): Unit = {
    println("Support files for Java class sharing:")
    <b>val</b> cdsUrl = getClass().getProtectionDomain().getCodeSource().getLocation()
    <b>val</b> libDir = java.nio.file.Paths.get(cdsUrl.toURI()).getParent().toFile()
    <b>val</b> files = libDir.listFiles.filter(_.getName.startsWith("dotty-cds"))
    files.foreach(f => println("   "+f.getName()+" ("+(f.length()/1024)+" Kb)"))
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
Statistics of shared vs. file/jrt classes
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
Statistics of shared vs. file/jrt classes
Shared classes: 942, file/jrt classes: 3
(see W:\dotty\data-sharing\logs\dotty-cds-repl-share.log)
</pre>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/December 2018* [**&#9650;**](#top)
