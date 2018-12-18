# <span id="top">Data Sharing and Dotty on Windows</span> (*work-in-progress*)

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This page presents findings from my experiments with <a href="https://docs.oracle.com/javase/8/docs/technotes/guides/vm/class-data-sharing.html">Java class data sharing</a> (CDS) and <a href="http://dotty.epfl.ch/">Dotty</a> on the Windows platform. Introduced in <a href="https://openjdk.java.net/groups/hotspot/docs/RuntimeOverview.html#Class%20Data%20Sharing|outline">J2SE 5.0</a>, CDS helps reduce the startup time for Java applications as well as reduce their memory footprint.
  </td>
  </tr>
</table>

This page is part of a series of topics related to [Dotty](http://dotty.epfl.ch/) on Windows:

- [Running Dotty on Windows](README.md)
- [Building Dotty on Windows](DRONE.md)
- Data Sharing and Dotty on Windows


## Project dependencies

This project depends on two external software for the **Microsoft Windows** platform:

- [Oracle Java 11 SDK](https://docs.oracle.com/en/java/javase/11/) ([*release notes*](https://www.oracle.com/technetwork/java/javase/11-0-1-relnotes-5032023.html))
- [Dotty 0.11](https://github.com/lampepfl/dotty/releases) (Java 9+ supported since 0.10)

> **:mag_right:**
> [Scala 2.12](https://www.scala-lang.org/download/) is a software product announced to require Java 8; in contrast [Dotty](http://dotty.epfl.ch/) (aka [Scala 3](https://www.scala-lang.org/blog/2018/04/19/scala-3.html)) is still in development and also supports Java 9+. In the following we choose to work with [Java 11](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html), the 2<sup>nd</sup> [LTS](https://www.oracle.com/technetwork/java/java-se-support-roadmap.html) version after Java 8.


## Overview

- Section **Java Example** presents a Java code example using data sharing.
- In section **Dotty Example** we move to [Dotty](http://dotty.epfl.ch/) with the same example written in [Dotty](http://dotty.epfl.ch/).
- Finally we describe the batch command **`sharedata.bat`**.

> **:warning:** We have submitted a bug report related to the usage of option **`-Xlog`** on Windows (see [JDK-8215398](https://bugs.java.com/bugdatabase/view_bug.do?bug_id=JDK-8215398)): 

## Java Example

The [**`build`**](cdsexamples/JavaExemple/build.bat) batch command has two new two options working with the **`run`** subcommand:

- Option **`-share`** enables/disables data sharing.
- Option **`-iter`** specifies the number of run iterations (for calculating meaningful average load times).

Internally we generate a Java shared archive as a last step of the compilation phase (**`compile`** subcommand):

<pre style="font-size:80%;">
> build help
Usage: build { options | subcommands }
  Options:
    -iter:1..99        set number of run iterations
    -share[:(on|off)]  enable/disable data sharing (default:off)
    -verbose           display progress messages
  Subcommands:
    clean              delete generated files
    compile            compile Java source files
    help               display this help message
    run                execute main class
</pre>

We first execute the following command:

<pre style="font-size:80%;">
&gt; build -verbose clean compile
Create Java archive target\JavaExample.jar
Create class list file target\JavaExample.classlist
Create Java shared archive target\JavaExample.jsa
</pre>

Let's check the generated files in directory **`target\`**:

<pre style="font-size:80%;">
&gt; tree /a /f target |findstr /v "^[A-Z]"
|   JavaExample.classlist
|   JavaExample.jar
|   JavaExample.jsa
|   MANIFEST.MF
|
+---classes
|   |   .latest-build
|   |
|   \---cdsexamples
|           JavaExample.class
|
\---logs
        log_classlist.log
        log_dump.log
</pre>

Here are a few observations:

- File **`MANIFEST.MF`** is added to **`JavaExample.jar`** as usual. 
- *[option **`-verbose`**]* File **`logs\log_classlist.log`** contains the execution log for the generation of **`JavaExample.classlist`**.
- *[option **`-verbose`**]* File **`logs\log_dump.log`** contains the execution log for the generation of **`JavaExample.jsa`**.

We can now execute our Java example ***without data sharing*** (default settings: **`-share:off`**):

<pre style="font-size:80%;">
&gt; build -verbose run
Hello from Java !
Statistics (see details in target\logs\log_share_off.log):
   Share flag       : off
   Shared classes   : 0
   File/jrt classes : 591
   Average load time: 0.117s
   #iteration(s)    : 1
Packages (590):
   java.io.* (36), java.lang.* (167), java.net.* (9)
   java.nio.* (38), java.security.* (23), java.util.* (136)
   jdk.* (107), sun.* (74)
</pre>

For comparison here is the output ***with data sharing***:

<pre style="font-size:80%;">
&gt; build -verbose run -share
Hello from Java !
Statistics (see details in target\logs\log_share_on.log):
   Share flag       : on
   Shared classes   : 513
   File/jrt classes : 1
   Average load time: 0.077s
   #iteration(s)    : 1
Packages (513):
   java.io.* (31), java.lang.* (151), java.net.* (9)
   java.nio.* (27), java.security.* (22), java.util.* (116)
   jdk.* (92), sun.* (65)
</pre>

With option **`-iter:<n>`** the **`run`** subcommand executes **`n`** times the Java example:

<pre style="font-size:80%;">
&gt; build -verbose run -share -iter:4
Hello from Java !
Hello from Java !
Hello from Java !
Hello from Java !
Statistics (see details in target\logs\log_share_on.log):
   Share flag       : on
   Shared classes   : 513
   File/jrt classes : 1
   Average load time: 0.084s
   #iteration(s)    : 4
Packages (513):
   java.io.* (31), java.lang.* (151), java.net.* (9)
   java.nio.* (27), java.security.* (22), java.util.* (116)
   jdk.* (92), sun.* (65)
</pre>

> **&#9755;** ***Data Sharing and JDK 11 Installation*** <br/>
> The [Java 11](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html) installation contains the file **`<jdk_path>\lib\classlist`**. Running command **`java.exe -Xshare:dump`** will read that file and generate a 17.3 Mb Java shared archive **`<jdk_path>\bin\server\classes.jsa`**.
> <pre style="font-size:80%;">
&gt; java -version 2>&1 | findstr version
openjdk version "11.0.1" 2018-10-16
&nbsp;
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
&nbsp;
&gt; dir /b c:\opt\jdk-11.0.1\bin\server
classes.jsa
jvm.dll
</pre>

## Dotty Example

The [**`build`**](cdsexamples/DottyExemple/build.bat) batch command has two new two options working with the **`run`** subcommand:

- Option **`-share`** enables/disables data sharing.
- Option **`-iter`** specifies the number of run iterations (for calculating meaningful average load times).

Internally we generate a Java shared archive as a last step of the compilation phase (**`compile`** subcommand):

<pre style="font-size:80%;">
&gt; build help
Usage: build { options | subcommands }
  Options:
    -iter:1..99        set number of run iterations
    -share[:(on|off)]  enable/disable data sharing (default:off)
    -verbose           display progress messages
  Subcommands:
    clean              delete generated files
    compile            compile Scala source files
    help               display this help message
    run                execute main class
</pre>

Similarly to the previous section we execute the following command:

<pre style="font-size:80%;">
&gt; build -verbose clean compile
Create Java archive target\DottyExample.jar
Create class list file target\DottyExample.classlist
Create Java shared archive target\DottyExample.jsa
</pre>

Let's now check the generated output in directory **`target\`**:

<pre style="font-size:80%;">
> tree /a /f target |findstr /v "^[A-Z]"
|   DottyExample.classlist
|   DottyExample.jar
|   DottyExample.jsa
|   MANIFEST.MF
|
+---classes
|   |   .latest-build
|   |
|   \---cdsexamples
|           Main$.class
|           Main.class
|           Main.tasty
|
\---logs
        log_classlist.log
        log_dump.log
</pre>

Here are a few observations:

- File **`MANIFEST.MF`** is added to **`DottyExample.jar`** as usual.
- Files **`classes\Main$.class`** and **`classes\Main.tasty`** (typed AST) are specific to the [Dotty](http://dotty.epfl.ch/) compiler.
- *(option **`-verbose`**)* File **`logs\log_classlist.log`** contains the execution log for the generation of **`DottyExample.classlist`**.
- *(option **`-verbose`**)* File **`logs\log_dump.log`** contains the execution log for the generation of **`DottyExample.jsa`**.


## Batch command

The [**`sharedata`**](bin/sharedata.bat) batch command:

<pre style="font-size:80%;">
&gt; sharedata help
Usage: sharedata { options | subcommands }
  Options:
    -share[:(on|off)]  set the share flag (default:off)
    -verbose           display generation progress
  Subcommands:
    activate           install the Java shared archive
    dump               create the Java shared archive
    help               display this help message
    reset              uninstall the Java shared archive
    test               execute test application (depends on dump)
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

## References


<a name="ref_01">[1]</a> <a href="http://openjdk.java.net/jeps/250">**JEP 250**</a>: Store Interned Strings in CDS Archives *(2014-09-24)*

<div style="margin:0 0 1em 20px;">
Interned strings are now stored in CDS archives.
</div>

<a name="ref_02">[2]</a> <a href="https://openjdk.java.net/jeps/310">**JEP 310**</a>: Application Class-Data Sharing *(2017-08-08)*

<div style="margin:0 0 1em 20px;">
To improve startup and footprint, AppCDS extends the existing CDS feature to allow application classes to be placed in the shared archive.
</div>

<a name="ref_03">[3]</a> <a href="https://bugs.openjdk.java.net/browse/JDK-8198565">**JDK-8198565**</a>: Extend CDS to Support the Module Path *(2018-02-22)*

<div style="margin:0 0 1em 20px;">
In JDK 11, CDS has been improved to support archiving classes from the module path.
</div>

<a name="ref_04">[4]</a> <a href="https://openjdk.java.net/jeps/341">**JEP 341**</a>: Default CDS Archives *(2018-06-01)*

<div style="margin:0 0 1em 20px;">
The JDK build process now generates a CDS archive, using the default class list, on 64-bit platforms.
</div>

<!--
## Footnotes

<a name="footnote_01">[1]</a> ***2018-08-17*** [↩](#anchor_01)

<div style="margin:0 0 1em 20px;">
</div>
-->
***

*[mics](http://lampwww.epfl.ch/~michelou/)/December 2018* [**&#9650;**](#top)
