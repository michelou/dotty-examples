# <span id="top">Running Dotty on Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:60px;max-width:100px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;" src="docs/dotty.png" alt="Dotty logo"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This repository gathers <a href="https://dotty.epfl.ch/" rel="external">Dotty</a> code examples coming from various websites - mostly from the <a href="https://dotty.epfl.ch/" rel="external">Dotty</a> project - or written by myself.<br/>
    In particular it includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>/<a href="https://www.gnu.org/software/bash/manual/bash.html" rel="external">bash scripts</a> for experimenting with the Dotty language (aka <a href="https://www.scala-lang.org/blog/2018/04/19/scala-3.html" rel="external">Scala 3</a>) on a Windows machine.
  </td>
  </tr>
</table>

This document is part of a series of topics related to [Dotty] on Windows:

- Running Dotty on Windows [**&#9660;**](#bottom)
- [Building Dotty on Windows](BUILD.md)
- [Data Sharing and Dotty on Windows](CDS.md)
- [OpenJDK and Dotty on Windows](OPENJDK.md)

[JMH], [Metaprogramming][dotty_metaprogramming], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples] and [TruffleSqueak][trufflesqueak_examples] are other trending topics we are currently monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on two external software for the **Microsoft Windows** platform:

- [Dotty 0.27][dotty_releases] ([*release notes*][dotty_relnotes])
- [Git 2.29][git_releases] ([*release notes*][git_relnotes])
- [Oracle OpenJDK 11][oracle_openjdk] <sup id="anchor_01">[[1]](#footnote_01)</sup> ([*release notes*][oracle_openjdk_relnotes])
<!--
8u212  -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-April/009115.html
8u222  -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-July/009840.html
8u232  -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-October/010452.html
8u242  -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2020-January/010979.html
8u252  -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2020-April/011559.html
11.0.8 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2020-April/003019.html
11.0.8 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2020-July/003498.html
-->
Optionally one may also install the following software:

- [Apache Ant 1.10][apache_ant] (requires Java 8) ([*release notes*][apache_ant_relnotes])
- [Apache Maven 3.6][apache_maven] ([requires Java 7][apache_maven_history])  ([*release notes*][apache_maven_relnotes])
- [Bazel 3.6][bazel_releases] <sup id="anchor_02">[[2]](#footnote_02)</sup> ([*release notes*][bazel_relnotes])
- [CFR 0.15][cfr_releases] (Java decompiler)
- [GNU Make 3.81][make_downloads]
- [Gradle 6.7][gradle_install] ([requires Java 8 or newer][gradle_compatibility]) ([*release notes*][gradle_relnotes])
- [JaCoCo 0.8][jacoco_downloads] ([*change log*][jacoco_changelog])
- [Mill 0.8][mill_releases] ([*change log*][mill_changelog])
- [SBT 1.4][sbt_downloads] (requires Java 8) ([*release notes*][sbt_relnotes])
- [Scala 2.13][scala_releases] (requires Java 8) ([*release notes*][scala_relnotes])
<!--
- [Bloop 1.3][bloop_releases] (requires Java 8 and Python 2/3) ([*release notes*][bloop_relnotes])
- [Python 3.8][python_release] ([*change log*][python_changelog])
-->

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a [Windows installer][windows_installer]. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][unix_opt] directory on Unix).

For instance our development environment looks as follows (*October 2020*) <sup id="anchor_03">[[3]](#footnote_03)</sup>:

<pre style="font-size:80%;">
C:\opt\jdk-11.0.8+10\        <i>(181.0 MB)</i>
C:\opt\apache-ant-1.10.9\    <i>( 39.7 MB)</i>
C:\opt\apache-maven-3.6.3\   <i>( 10.7 MB)</i>
C:\opt\bazel-3.6.0\          <i>( 40.0 MB)</i>
C:\opt\cfr-0.150\            <i>(  1.9 MB)</i>
C:\opt\dotty-0.27.0-RC1\     <i>( 27.3 MB)</i>
C:\opt\Git-2.29.0\           <i>(290.0 MB)</i>
C:\opt\gradle-6.7\           <i>(111.0 MB)</i>
C:\opt\jacoco-0.8.6\         <i>( 10.6 MB)</i>
C:\opt\make-3.81\            <i>(  2.1 MB)</i>
C:\opt\Mill-0.8.0\           <i>( 53.7 MB)</i>
C:\opt\sbt-1.4.1\            <i>( 61.3 MB)</i>
C:\opt\scala-2.13.3\         <i>( 22.8 MB, 588 MB with API docs)</i>
</pre>
 <!-- jdk: 242-b08 = 184 MB, 252-b09 = 181 MB , 262-b10 = 184 MB -->
 <!-- sbt: 1.3.6 = 55.1 MB, 1.3.7 = 60.9 MB, 1.3.8 = 61.0 MB -->
 <!-- sbt: 1.3.9 = 61.2 MB, 1.3.10 = 61.2 MB, 1.3.11 = 61.3 MB -->

> **:mag_right:** [Git for Windows][git_releases] provides a Bash emulation used to run [**`git`**][git_cli] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

## <span id="structure">Directory structure</span>

This project is organized as follows:

<pre style="font-size:80%;">
bin\*.bat
bin\cfr-0.150.zip
bin\3.0.0\{<a href="bin/3.0.0/scalac.bat">scalac.bat</a>, <a href="bin/3.0.0/scala.bat">scala.bat</a>, ..}
bin\dotty\
docs\
dotty\     <i>(Git submodule)</i>
examples\{<a href="examples/README.md">README.md</a>, dotty-example-project, ..}
myexamples\{<a href="myexamples/README.md">README.md</a>, 00_AutoParamTupling, ..}
plugin-examples\{<a href="plugin-examples/README.md">README.md</a>, DivideZero, ..}
README.md
<a href="setenv.bat">setenv.bat</a>
</pre>

where

- directory [**`bin\`**](bin/) provides several utility [batch files][windows_batch_file].
- file [**`bin\cfr-0.150.zip`**](bin/cfr-0.150.zip) contains a zipped distribution of [CFR][cfr_releases].
- directory [**`bin\3.0.0\`**](bin/3.0.0/) contains the batch commands for [Scala 3][dotty_relnotes].
- directory [**`bin\dotty\`**](bin/dotty/) contains several [batch files][windows_batch_file]/[bash scripts][unix_bash_script] for building the [Dotty] software distribution on a Windows machine.
- directory [**`docs\`**](docs/) contains [Dotty] related papers/articles (see file [**`docs\README.md`**](docs/README.md)).
- directory **`dotty\`** contains our fork of the [lampepfl/dotty][github_lampepfl_dotty] repository as a [Github submodule](.gitmodules).
- directory [**`examples\`**](examples/) contains [Dotty] examples grabbed from various websites (see file [**`examples\README.md`**](examples/README.md)).
- directory [**`myexamples\`**](myexamples/) contains self-written [Dotty] examples (see file [**`myexamples\README.md`**](myexamples/README.md)).
- directory [**`plugin-examples\`**](plugin-examples/) contains [Dotty] plugin examples (see file [**`plugin-examples\README.md`**](plugin-examples/README.md)).
- file [**`README.md`**](README.md) is the [Markdown][github_markdown] document for this page.
- file [**`setenv.bat`**](setenv.bat) is the batch command for setting up our environment.

<!--
> **:mag_right:** We use [VS Code][microsoft_vscode] with the extension [Markdown Preview Github Styling](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-preview-github-styles) to edit our Markdown files (see article ["Mastering Markdown"](https://guides.github.com/features/mastering-markdown/) from [GitHub Guides][github_guides].
-->

We also define a virtual drive **`W:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).
> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> W: %USERPROFILE%\workspace\dotty-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## <span id="commands">Batch/Bash commands</span>

We distinguish different sets of batch/bash commands:

1. [**`setenv.bat`**](setenv.bat) - This batch command makes external tools such as [**`javac.exe`**][javac_cli], [**`scalac.bat`**][scalac_cli] and [**`dotc.bat`**](bin/0.27/dotc.bat)directly available from the command prompt (see section [**Project dependencies**](#proj_deps)).

   <pre style="font-size:80%;">
   <b>&gt; <a href="setenv.bat">setenv</a> help</b>
   Usage: setenv { &lt;option&gt; | &lt;subcommand&gt; }
   &nbsp;
     Options:
       -bash       start Git bash shell instead of Windows command prompt
       -debug      show commands executed by this script
       -verbose    display environment settings
   &nbsp;
     Subcommands:
       help        display this help message
   </pre>

2. Directory [**`bin\`**](bin/) - This directory contains several utility batch files:
   - [**`cleanup.bat`**](bin/cleanup.bat) removes the generated class files from every example directory (both in [**`examples\`**](examples/) and [**`myexamples\`**](myexamples/) directories).
   - [**`dirsize.bat <dir_path_1> ..`**](bin/dirsize.bat) prints the size in Kb/Mb/Gb of the specified directory paths.
   - [**`getnightly.bat`**](bin/getnightly.bat) downloads/installs the library files from the latest [Dotty nightly build](https://search.maven.org/search?q=g:ch.epfl.lamp).
   - [**`searchjars.bat <class_name>`**](bin/searchjars.bat) searches for the given class name into all Dotty/Scala JAR files.
   - [**`timeit.bat <cmd_1> { & <cmd_2> }`**](bin/timeit.bat) prints the execution time of the specified commands.
   - [**`touch.bat <file_path>`**](bin/touch.bat) updates the modification date of an existing file or creates a new one.<div style="font-size:8px;">&nbsp;</div>

3. Directory [**`bin\3.0.0\`**](bin/3.0.0/) - This directory contains batch files to be copied to the **`bin\`** directory of the [Dotty] installation (eg. **`C:\opt\scala-3.0.0-M1\bin\`**) in order to use the [**`scalac`**](bin/3.0.0/scalac.bat), [**`scalad`**](bin/3.0.0/scalad.bat) and [**`scala`**](bin/3.0.0/scala.bat) commands on **Microsoft Windows**.
    > **&#9755;** We wrote (and do maintain) those batch files based on the bash scripts available from the official [Dotty distribution][dotty_releases]. We also have submitted pull request [#5444][github_PR5444] to add them to the Dotty distribution.

    <pre style="font-size:80%;">
    <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b c:\opt\dotty-3.0.0-M1\bin</b>
    <a href="https://github.com/lampepfl/dotty/blob/master/dist/bin/common">common</a>
    <a href="bin/3.0.0/common.bat">common.bat</a>
    <a href="https://github.com/lampepfl/dotty/blob/master/dist/bin/scalac">scalac</a>
    <a href="bin/3.0.0/scalac.bat">scalac.bat</a>
    <a href="https://github.com/lampepfl/dotty/blob/master/dist/bin/scalad">scalad</a>
    <a href="bin/3.0.0/scalad.bat">scalad.bat</a>
    <a href="https://github.com/lampepfl/dotty/blob/master/dist/bin/scala">scala</a>
    <a href="bin/3.0.0/scala.bat">scala.bat</a>
    </pre>

<!-- ## removed on 2018-10-05 ##
    > **NB.** Prior to version 0.9-RC1 the [**`dotr`**](bin/0.9/dotr.bat) command did hang on Windows due to implementation issues with the Dotty [REPL](https://en.wikipedia.org/wiki/Read–eval–print_loop). This [issue](https://github.com/lampepfl/dotty/pull/4680) has been fixed by using [JLine 3](https://github.com/jline/jline3) in the REPL.
-->

4. File [**`bin\dotty\build.bat`**](bin/dotty/build.bat) - This batch command generates the [Dotty] software distribution from the Windows command prompt.

5. File [**`bin\dotty\build.sh`**](bin/dotty/build.sh) - This bash command generates the [Dotty] software distribution from the [Git Bash][git_bash] command prompt.

6. File [**`examples\*\build.bat`**](examples/dotty-example-project/build.bat) - Finally each example can be built/run using the [**`build`**](examples/dotty-example-project/build.bat) command.<br/>
    > **&#9755;** We favor [**`build.bat`**](examples/dotty-example-project/build.bat) for 3 reasons:
    > - it matches user commands executed from the the command prompt
    > - code examples are simple (mostly one single source file)
    > - we don't need the [**`sbt`** ][sbt_cli] machinery (eg. [library dependencies][sbt_libs], [sbt server][sbt_server]).

    <pre style="font-size:80%;">
    <b>&gt; <a href="examples/dotty-example-project/build.bat">build</a></b>
    Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
    &nbsp;
      Options:
        -debug           show commands executed by this script
        -dotty           use Scala 3 tools (default)
        -explain         set compiler option -explain
        -explain-types   set compiler option -explain-types
        -main:&lt;name&gt;     define main class name (default: Main)
        -print           print IR after compilation phase 'lambdaLift'
        -scala           use Scala 2 tools
        -tasty           compile both from source and <a href="https://github.com/lampepfl/dotty/blob/master/tasty/src/dotty/tools/tasty/TastyFormat.scala">TASTy files</a>
        -timer           display the compile time
        -verbose         display progress messages
    &nbsp;
      Subcommands:
        clean            delete generated class files
        compile          compile Java/Scala source files
        decompile        decompile generated code with <a href="https://www.benf.org/other/cfr/"><b>CFR</b></a>
        doc              generate HTML documentation
        help             display this help message
        lint             analyze Scala source files with <a href="https://scalameta.org/scalafmt/">Scalafmt</a>
        run[:i]          execute main class (instrumented execution: :i)
        test             execute unit tests with <a href="https://junit.org/junit4/">JUnit</a>
    &nbsp;
      Properties:
      (to be defined in SBT configuration file project\build.properties)
        main.class       alternative to option -main
        main.args        list of arguments to be passed to main class
    </pre>

## <span id="tools">Optional tools</span>

1. Build tools

    Code examples in directories [**`examples\`**](examples/) and [**`myexamples\`**](myexamples/) can also be built with the following tools as an alternative to the **`build`** command (see [**`examples\README.md`**](examples/README.md) and [**`myexamples\README.md`**](myexamples/README.md) for more details):

    | **Build tool** | **Configuration file** | **Parent file** | **Usage example** |
    | :------------- | :--------------------- | :-------------- | :---------------- |
    | [**`ant.bat`**][apache_ant_cli] | [**`build.xml`**](examples/enum-Planet/build.xml) | [**`build.xml`**](examples/build.xml) | **`ant clean compile run`** |
    | [**`bazel.exe`**][bazel_cli] | [**`BUILD`**](examples/enum-Planet/BUILD) | n.a. | **`bazel run :enum-Planet`** |
    | [**`build.bat`**](examples/enum-Planet/build.bat) | **`build.properties`** | n.a. | **`build clean run`** |
    | [**`gradle.bat`**][gradle_cli] | [**`build.gradle`**](examples/enum-Planet/build.gradle) | [**`common.gradle`**](examples/common.gradle) | **`gradle clean build run`** |
    | [**`make.exe`**][gmake_cli] | [**`Makefile`**](examples/enum-Planet/Makefile) | [**`Makefile.inc`**](examples/Makefile.inc) | **`make clean run`** |
    | [**`mill.bat`**][mill_cli] | [**`build.sc`**](examples/enum-Planet/build.sc) | [**`common.sc`**](examples/common.sc) | **`mill -i app`** |
    | [**`mvn.cmd`**][apache_maven_cli] | [**`pom.xml`**](examples/enum-Planet/pom.xml) | [**`pom.xml`**](examples/pom.xml) | **`mvn clean compile test`** |
    | [**`sbt.bat`**][sbt_cli] | [**`build.sbt`**](examples/enum-Planet/build.sbt) | n.a. | **`sbt clean compile run`** |

2. Decompiler tools

    As an alternative to the standard [**`javap`**][javap_cli] class decompiler one may use **`cfr.bat`** (simply extract [**`bin\cfr-0.150.zip`**](bin/cfr-0.150.zip) to **`c:\opt\`**) which prints [Java source code][java_jls] instead of [Java bytecode][java_bytecode]:

    <pre style="font-size:80%;">
    <b>&gt; <a href="https://www.benf.org/other/cfr/">cfr</a> myexamples\00_AutoParamTupling\target\classes\myexamples\Main.class</b>
    /*
     * Decompiled with CFR 0.150.
     */
    <b>package</b> myexamples;
    
    <b>import</b> myexamples.Main$;
    
    <b>public final class</b> Main {
        <b>public static void</b> test01() {
            Main$.MODULE$.test01();
        }
    
        <b>public static void</b> main(String[] arrstring) {
            Main$.MODULE$.main(arrstring);
        }
    
        <b>public static void</b> test02() {
            Main$.MODULE$.test02();
        }
    }
    </pre>

    Here is the console output from command [**`javap`**][javap_cli] with option **`-c`** for the same class file:

    <pre style="font-size:80%;">
    <b>&gt; <a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javap.html">javap</a> -c myexamples\00_AutoParamTupling\target\classes\myexamples\Main.class</b>
    Compiled from "Main.scala"
    public final class myexamples.Main {
      public static void main(java.lang.String[]);
        Code:
           0: getstatic     #13                 // Field myexamples/Main$.MODULE$:Lmyexamples/Main$;
           3: aload_0
           4: invokevirtual #15                 // Method myexamples/Main$.main:([Ljava/lang/String;)V
           7: return
    
      public static void test02();
        Code:
           0: getstatic     #13                 // Field myexamples/Main$.MODULE$:Lmyexamples/Main$;
           3: invokevirtual #19                 // Method myexamples/Main$.test02:()V
           6: return
    
      public static void test01();
        Code:
           0: getstatic     #13                 // Field myexamples/Main$.MODULE$:Lmyexamples/Main$;
           3: invokevirtual #22                 // Method myexamples/Main$.test01:()V
           6: return
    }
    </pre>

## <span id="examples">Usage examples</span>

### **`setenv.bat`**

Command [**`setenv`**](setenv.bat) is executed once to setup our development environment; it makes external tools such as [**`bazel.exe`**][bazel_cli], [**`mvn.cmd`**][apache_maven_cli], [**`sbt.bat`**][sbt_cli] and [**`git.exe`**][git_cli] directly available from the command prompt.

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a></b>
Tool versions:
   javac 11.0.8, java 11.0.8, scalac 2.13.3, scalac 3.0.0-M1,
   ant 1.10.9, gradle 6.7, mill 0.8.0, mvn 3.6.3, sbt 1.4.1,
   bazel 3.6.0, bloop v1.3.4, cfr 0.150, make 3.81, python 3.8.6,
   git 2.29.0.windows.1, diff 3.7, bash 4.4.23(1)-release

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> sbt</b>
C:\opt\sbt-1.4.1\bin\sbt
C:\opt\sbt-1.4.1\bin\sbt.bat
</pre>

> **:mag_right:** Other external tools such as [**`javac.exe`**][javac_cli], [**`scalac.bat`**][scalac_cli] or **`dotc.bat`** are accessible through the corresponding environment variable, e.g. **`JAVA_HOME`** for **`javac.exe`** (and so on).

Command [**`setenv -verbose`**](setenv.bat) also displays the tool paths and defined variables:

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a> -verbose</b>
Tool versions:
   javac 11.0.8, java 11.0.8, scalac 2.13.3, scalac 3.0.0-M1,
   ant 1.10.9, gradle 6.7, mill 0.8.0, mvn 3.6.3, sbt 1.4.1,
   bazel 3.6.0, bloop v1.3.4, cfr 0.150, make 3.81, python 3.8.6,
   git 2.29.0.windows.1, diff 3.7, bash 4.4.23(1)-release
Tool paths:
   C:\opt\jdk-11.0.8+10\bin\javac.exe
   C:\opt\jdk-11.0.8+10\bin\java.exe
   C:\opt\scala-2.13.3\bin\scalac.bat
   C:\opt\scala-3.0.0-M1\bin\scalac.bat
   C:\opt\apache-ant-1.10.9\bin\ant.bat
   C:\opt\gradle-6.7\bin\gradle.bat
   C:\opt\Mill-0.8.0\mill.bat
   C:\opt\apache-maven-3.6.3\bin\mvn.cmd
   C:\opt\sbt-1.4.1\bin\sbt.bat
   C:\opt\bazel-3.6.0\bazel.exe
   C:\opt\bloop-1.3.4\bloop.cmd
   C:\opt\cfr-0.150\bin\cfr.bat
   C:\opt\make-3.81\bin\make.exe
   C:\opt\Python-3.8\python.exe
   C:\opt\Git-2.29.0\bin\git.exe
   C:\opt\Git-2.29.0\mingw64\bin\git.exe
   C:\opt\Git-2.29.0\usr\bin\diff.exe
   C:\opt\Git-2.29.0\bin\bash.exe
Environment variables:
   ANT_HOME=C:\opt\apache-ant-1.10.9
   GIT_HOME=C:\opt\Git-2.29.0
   JAVA_HOME=C:\opt\jdk-11.0.8+10
   JAVAFX_HOME=C:\opt\javafx-sdk-14.0.2.1
   PYTHON_HOME=C:\opt\Python-3.8
   SCALA_HOME=C:\opt\scala-2.13.3
   SCALA3_HOME=C:\opt\scala-3.0.0-M1
   SCALAFMT_HOME=C:\opt\scalafmt-2.6.4
</pre>

### **`cleanup.bat`**

Command [**`cleanup`**](bin/cleanup.bat) removes the output directories (ie. **`target\`**) from the example projects: 

<pre style="font-size:80%;">
<b>&gt; <a href="bin/cleanup.bat">cleanup</a></b>
Finished to clean up 2 subdirectories in W:\dotty\cdsexamples
Finished to clean up 16 subdirectories in W:\dotty\examples
Finished to clean up 12 subdirectories in W:\dotty\myexamples
</pre>

### **`dirsize.bat {<dir_name>}`**

Command [**`dirsize`**](bin/dirsize.bat) returns the size (in Kb, Mb or Gb) of the specified directory paths:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/dirsize.bat">dirsize</a> examples myexamples c:\opt\scala-3.0.0-M1 c:\opt\jdk-11.0.8+10</b>
Size of directory "examples" is 3.9 Mb
Size of directory "myexamples" is 1.2 Mb
Size of directory "c:\opt\scala-3.0.0-M1" is 26.7 Mb
Size of directory "c:\opt\jdk-11.0.8+10" is 184.2 Mb
</pre>

### **`getnightly.bat`**

By default command [**`getnightly`**](bin/getnightly.bat) downloads the library files of the latest [Dotty nightly build][dotty_nightly] available from the [Maven Central Repository][maven_lamp] and saves them into directory **`out\nightly-jars\`**.

<pre style="font-size:80%;">
<b>&gt; <a href="bin/getnightly.bat">getnightly</a></b>

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b out\nightly-jars</b>
scala3-compiler_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
scala3-doc_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
scala3-interfaces-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
scala3-language-server_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
scala3-library_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
scala3-library_sjs1_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
scala3-sbt-bridge-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
scala3-staging_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
scala3-tasty-inspector_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
scala3-tastydoc-input_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
scala3-tastydoc_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
tasty-core_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar 
</pre>

> **:mag_right:** A few notes about the distributed Java archives:
> - Dotty versions up to `0.18.0` depend on **`scala-library-2.12.8.jar`**; Dotty versions `0.18.1` and newer depend on **`scala-library-2.13.x.jar`**.
> - Starting with Dotty version `0.22.0` package **`dotty.tools.tasty`** is distributed separately in archive **`tast-core_<xxx>.jar`**.
> - Starting with Dotty version `0.28.0` package **`dotty-library_sjs1.x.jar`** is part of the software distribution.<br/>&nbsp;


Command [**`getnightly -verbose`**](bin/getnightly.bat) also displays the download progress:

<pre style="font-size:80%">
<b>&gt; <a href="bin/getnightly.bat">getnightly</a> -verbose</b>
Check for nightly files on Maven repository
Downloading file dotty-library_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 1.3 Mb
Downloading file tasty-core_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 51.6 Kb
Downloading file dotty-library_sjs1_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 2.2 Mb
Downloading file dotty-tastydoc-input_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 36.1 Kb
Downloading file dotty-compiler_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 12.8 Mb
Downloading file dotty-doc_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 1 Mb
Downloading file dotty-sbt-bridge-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 13.4 Kb
Downloading file dotty-language-server_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 145.6 Kb
Downloading file dotty-tastydoc_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 434.3 Kb
Downloading file dotty-staging_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 35.5 Kb
Downloading file dotty-interfaces-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 3.4 Kb
Downloading file dotty-tasty-inspector_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 8 Kb
Downloading file dotty_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar ... 0.3 Kb
Finished to download 13 files to directory W:\out\nightly-jars
Nightly version is 3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.
</pre>

We can now replace the library files from the original [Dotty distribution][dotty_releases] (installed in directory **`C:\opt\dotty-0.27.0-RC1\`** in our case) with library files from the latest nightly build.

Concretely, we specify the **`activate`** subcommand to switch to the nightly build version and the **`reset`** subcommand to restore the original library files in the [Dotty] installation directory.

<pre style="font-size:80%;">
<b>&gt; <a href="bin/getnightly.bat">getnightly</a> activate</b>
Local nightly version has changed from 3.0.0-M1 to 3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.
Activate nightly build libraries: 3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.

<b>&gt; <a href="bin/3.0.0/scalac.bat">scalac</a> -version</b>
Dotty compiler version 3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.-git-97da3cb -- Copyright 2002-2020, LAMP/EPFL

<b>&gt; <a href="bin/getnightly.bat">getnightly</a> reset</b>
Activate default Dotty libraries: 3.0.0-M1

<b>&gt; <a href="bin/3.0.0/scalac.bat">scalac</a> -version</b>
Dotty compiler version 3.0.0-M1-bin-20201021-97da3cb-NIGHTLY-git-97da3cb -- Copyright 2002-2020, LAMP/EPFL
</pre>

> **:warning:** You need *write access* to the [Dotty] installation directory (e.g. **`C:\opt\scala-3.0.0-M1\`** in our case) in order to successfully run the **`activate/reset`** subcommands.

Internally command [**`getnightly`**](bin/getnightly.bat) manages two sets of libraries files which are organized as follows:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/pushd">pushd</a> c:\opt\scala-3.0.0-M1&dir/b/a-d&for /f %i in ('dir/s/b/ad lib') do @(echo lib\%~nxi\&dir/b %i)&popd</b>
VERSION
lib\3.0.0-M1-bin-20201021-97da3cb-NIGHTLY\
&nbsp;&nbsp;scala3-compiler_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
&nbsp;&nbsp;scala3-doc_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
&nbsp;&nbsp;scala3-interfaces-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
&nbsp;&nbsp;scala3-language-server_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
&nbsp;&nbsp;scala3-library_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
&nbsp;&nbsp;scala3-library_sjs1_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
&nbsp;&nbsp;scala3-sbt-bridge-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
&nbsp;&nbsp;scala3-staging_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
&nbsp;&nbsp;scala3-tasty-inspector_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
&nbsp;&nbsp;scala3-tastydoc-input_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
&nbsp;&nbsp;scala3-tastydoc_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
&nbsp;&nbsp;tasty-core_3.0.0-M1-3.0.0-M1-bin-20201021-97da3cb-NIGHTLY.jar
</pre>

In the above output file **`VERSION-NIGHTLY`** contains the signature of the managed nightly build and the **`lib\`** directory contains two backup directories with copies of the library files from the original [Dotty] installation respectively from the latest nightly build.

### `searchjars.bat <class_name>`

Command [**`searchjars`**](bin/searchjars.bat) helps us to search for class file names in the following directories: project's **`lib\`** directory (*if present*), Dotty's **`lib\`** directory, Java's **`lib\`** directory and Ivy/Maven default directories.

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> -help</b>
Usage: searchjars { &lt;option&gt; | &lt;class_name&gt; }
&nbsp;
  Options:
    -artifact        include ~\.ivy2 and ~\.m2 directories
    -help            display this help message
    -ivy             include ~\.ivy directory
    -maven           include ~\.m2 directory
    -verbose         display download progress
&nbsp;
  Arguments:
    &lt;class_name&gt;     class name
</pre>

Passing argument **`System`** to command [**`searchjars`**](bin/searchjars.bat) prints the following output (class file names are printed with full path and are prefixed with their containing [JAR file][jar_file]:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> System</b>
Searching for class name System in archive files C:\opt\opt\dotty-0.27.0-RC1\lib\*.jar
  jline-reader-3.15.0.jar:org/jline/reader/impl/completer/SystemCompleter.class
  scala-library-2.13.3.jar:scala/sys/SystemProperties$.class
  scala-library-2.13.3.jar:scala/sys/SystemProperties.class
Searching for class name System in archive files C:\opt\scala-2.13.3\lib\*.jar
  jline-3.15.0.jar:org/jline/builtins/SystemRegistryImpl$CommandOutputStream.class
  [...]
  scala-library.jar:scala/sys/SystemProperties$.class
  scala-library.jar:scala/sys/SystemProperties.class
Searching for class name System in archive files C:\opt\jdk-11.0.8+10\lib\*.jar
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystem$1.class
  [...]
  jrt-fs.jar:jdk/internal/jrtfs/SystemImage$2.class
  jrt-fs.jar:jdk/internal/jrtfs/SystemImage.class
Searching for class name System in archive files c:\opt\javafx-sdk-11.0.2\lib\*.jar
  javafx.graphics.jar:com/sun/glass/ui/SystemClipboard.class
  [...]
  javafx.graphics.jar:com/sun/javafx/tk/TKSystemMenu.class
  javafx.web.jar:com/sun/webkit/FileSystem.class
</pre>

Searching for an unknown class name - e.g. **`BinarySearch`** - produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> BinarySearch</b>
Searching for class name BinarySearch in archive files C:\opt\dotty-0.27.0-RC1\lib\*.jar
Searching for class name BinarySearch in archive files C:\opt\scala-2.13.3\lib\*.jar
Searching for class name BinarySearch in archive files C:\opt\jdk-11.0.8+10\lib\*.jar
</pre>

Searching for **`FileSystem`** with option **`-artifact`** produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> FileSystem -artifact</b>
Searching for class name FileSystem in archive files C:\opt\dotty-0.27.0-RC1\lib\*.jar
Searching for class name FileSystem in archive files C:\opt\scala-2.13.3\lib\*.jar
Searching for class name FileSystem in archive files c:\opt\jdk-11.0.8+10\lib\*.jar
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystem$1.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystem.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystemProvider$1.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystemProvider$JrtFsLoader.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystemProvider.class
Searching for class name FileSystem in archive files c:\opt\javafx-sdk-11.0.2\lib\*.jar
  javafx.web.jar:com/sun/webkit/FileSystem.class
Searching for class name FileSystem in archive files %USERPROFILE%\.ivy2\cache\*.jar
  okhttp-3.14.2.jar:okhttp3/internal/io/FileSystem$1.class
  okhttp-3.14.2.jar:okhttp3/internal/io/FileSystem.class
  ivy-2.3.0-sbt-839fad1cdc07cf6fc81364d74c323867230432ad.jar:org/apache/ivy/plugins/resolver/FileSystemResolver.class
  ivy-2.3.0-sbt-88d6a93d15f9b029958c1c289a8859e8dfe31a19.jar:org/apache/ivy/plugins/resolver/FileSystemResolver.class
  ivy-2.3.0-sbt-fa726854dd30be842ff9e6d2093df6adfe3871f5.jar:org/apache/ivy/plugins/resolver/FileSystemResolver.class
Searching for class name FileSystem in archive files %USERPROFILE%\.m2\repository\*.jar
  commons-io-2.2.jar:org/apache/commons/io/FileSystemUtils.class
  commons-io-2.5.jar:org/apache/commons/io/FileSystemUtils.class
  commons-io-2.6.jar:org/apache/commons/io/FileSystemUtils.class
  ivy-2.4.0.jar:org/apache/ivy/plugins/resolver/FileSystemResolver.class
  sigar-1.6.4.jar:org/hyperic/sigar/FileSystem.class
  [...]
  stagemonitor-os-0.88.9.jar:org/stagemonitor/os/metrics/FileSystemMetricSet.class
</pre>

### `timeit.bat <cmd_1> { & <cmd_i> }`

Command [**`timeit`**](bin/timeit.bat) prints the execution time (`hh:MM:ss` format) of the specified command (possibly given with options and parameters):

<pre style="font-size:80%;">
<b>&gt; <a href="bin/timeit.bat">timeit</a> dir /b</b>
.gitignore
.gradle
build.bat
build.gradle
build.sbt
build.sc
build.xml
pom.xml
project
settings.gradle
src
target
Execution time: 00:00:01
&nbsp;
<b>&gt; <a href="bin/timeit.bat">timeit</a> build clean compile</b>
Execution time: 00:00:08
</pre>

Chaining of commands is also possible. Note that the command separator (either **`&&`** or **`&`**) must be escaped if the command chain is not quoted. For instance:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/timeit.bat">timeit</a> build clean compile ^&^& ant run</b>
...
Execution time: 00:00:11
<b>&gt; <a href="bin/timeit.bat">timeit</a> "build clean compile && ant run"</b>
...
Execution time: 00:00:11
</pre>

> **:mag_right:** The **`&&`** command separator performs error checking - that is, the commands to the right of the **`&&`** command run ***if and only if*** the command to the left of **`&&`** succeeds. The **`&`** command ***does not*** perform error checking - that is, all commands run.

<!--
### `touch.bat`

The [**`touch.bat`**](bin/touch.bat) command


### `updateprojs`

Command [**`updateprojs`**](bin/updateprojs.bat) updates the following software versions:

| Project file | Variable | Example |
| :----------- | :------: | :------ |
| `build.sbt` | `dottyVersion` | `0.26.0-RC1` &rarr; `0.27.0-RC1`|
| `build.sc` | `scalaVersion` | `0.26.0-RC1` &rarr; `0.27.0-RC1` |
| `project\build.properties` | `sbt.version` | `1.4.0` &rarr; `1.4.1` |
| `project\plugins.sbt` | `sbt-dotty` | `0.3.4` &rarr; `0.4.0` |

> **:construction:** Currently we have to edit the value pairs (old/new) directly in the batch file.

<pre style="margin:10px 0 0 30px;font-size:80%;">
<b>&gt; <a href="bin/updateprojs.bat">updateprojs</a></b>
Parent directory: W:\dotty\examples
   Warning: Could not find file hello-scala\project\plugins.sbt
   Warning: Could not find file UnionTypes_0.4\project\plugins.sbt
   Updated 17 build.sbt files
   Updated 17 project\build.properties files
   Updated 15 project\plugins.sbt files
Parent directory: W:\dotty\myexamples
   Warning: Could not find file 07_Value_Types\build.sbt
   Warning: Could not find file 07_Value_Types\project\build.properties
   Warning: Could not find file 07_Value_Types\project\plugins.sbt
   Updated 11 build.sbt files
   Updated 11 project\build.properties files
   Updated 11 project\plugins.sbt files
</pre>
-->

### `build.bat`

Command [**`build`**](examples/enum-Planet/build.bat) is a basic build tool consisting of ~800 lines of batch/[Powershell ][microsoft_powershell] code <sup id="anchor_04">[[4]](#footnote_04)</sup>.

Running command [**`build`**](examples/enum-Planet/build.bat) with ***no*** option in project [**`examples\enum-Planet`**](examples/enum-Planet/) generates the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="examples/enum-Planet/build.bat">build</a> clean compile run</b>
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on SATURN (5) is 1.0660155388115666
Your weight on VENUS (1) is 0.9049990998410455
Your weight on URANUS (6) is 0.9051271993894251
Your weight on EARTH (2) is 0.9999999999999999
Your weight on NEPTUNE (7) is 1.1383280724696578
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406</pre>

More usage examples are presented in [**`examples\README.md`**](examples/README.md) resp. [**`myexamples\README.md`**](myexamples/README.md)


### `scala.bat`

[Dotty REPL][dotty_repl] is an interactive tool for evaluating [Scala] expressions. Internally, it executes a source script by wrapping it in a template and then compiling and executing the resulting program.

   > **:warning:** Batch file [**`scala.bat`**](bin/3.0.0/scala.bat) is based on the bash script [**`scala`**][github_scala] available from the standard [Scala 3 distribution][dotty_releases]. We also have submitted pull request [#5444][github_PR5444] to add that batch file to the Dotty distribution.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> scala</b>
C:\opt\scala-3.0.0-M1\bin\scala
C:\opt\scala-3.0.0-M1\bin\scala.bat

<b>&gt; <a href="bin/3.0.0\scala.bat">scala</a> -version</b>
openjdk version "11.0.8" 2020-07-14
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.8+10)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.8+10, mixed mode, sharing)

<b>&gt; <a href="bin/3.0.0\scala.bat">scala</a></b>
Starting scala REPL...
scala> :help
The REPL has several commands available:

:help                    print this summary
:load &lt;path&gt;             interpret lines in a file
:quit                    exit the interpreter
:type &lt;expression&gt;       evaluate the type of the given expression
:imports                 show import history
:reset                   reset the repl to its initial state, forgetting all session entries

<b>scala&gt;</b> System.getenv().get("JAVA_HOME")
val res0: String = C:\opt\jdk-11.0.8+10

<b>scala&gt;</b> System.getenv().get("SCALA3_HOME")
val res1: String = C:\opt\scala-3.0.0-M1

<b>scala&gt;</b> :load myexamples/HelloWorld/src/main/scala/HelloWorld.scala
// defined object HelloWorld

<b>scala&gt;</b> HelloWorld.main(Array())
Hello world!

<b>scala&gt;</b>:quit
</pre>

## <span id="footnotes">Footnotes</span>

<b name="footnote_01">[1]</b> ***Java LTS*** [↩](#anchor_01) <!-- 2018-11-18 -->

<p style="margin:0 0 1em 20px;">
Oracle annonces in his <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">Java SE Support Roadmap</a> he will stop public updates of Java SE 8 for commercial use after January 2019. Launched in March 2014 Java SE 8 is classified an <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">LTS release</a> in the new time-based system and <a href="https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html">Java SE 11</a>, released in September 2018, is the current <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html" rel="external">LTS release</a>.
</p>

<b name="footnote_02">[2]</b> ***Using Bazel on Windows*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
Read the page <a href="https://docs.bazel.build/versions/master/windows.html#build-on-windows" rel="external">Builds on Windows</a> of the <a href="https://www.bazel.build/" rel="external">Bazel website</a> for tips to build with MSVC, Clang, Java or Python on a Windows machine.
</p>
<p style="margin:0 0 1em 20px;">
For instance, for Visual Studio 2019, we set variable <b><code>BAZEL_VC</code></b> to the Visual C++ Build Tools installation directory:
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a></b> BAZEL_VC=C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC
</pre>

<b name="footnote_03">[3]</b> ***Downloads*** [↩](#anchor_03)

<p style="margin:0 0 1em 20px;">
In our case we downloaded the following installation files (<a href="#proj_deps">see section 1</a>):
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<a href="https://github.com/lihaoyi/mill/releases">0.8.0-assembly</a> (<code>mill</code>)                            <i>(53 MB)</i>
<a href="https://ant.apache.org/bindownload.cgi">apache-ant-1.10.9-bin.zip</a>                        <i>( 9 MB)</i>
<a href="https://maven.apache.org/download.cgi">apache-maven-3.6.3-bin.zip</a>                       <i>( 9 MB)</i>
<a href="https://github.com/bazelbuild/bazel/releases">bazel-3.6.0-windows-x86_64.zip</a>                   <i>(38 MB)</i>
<a href="https://github.com/lampepfl/dotty/releases/tag/0.27.0-RC1">dotty-0.27.0-RC1.zip</a>                             <i>(24 MB)</i>
<a href="https://gradle.org/install/">gradle-6.7-bin.zip</a>                               <i>(97 MB)</i>
<a href="https://www.eclemma.org/jacoco/">jacoco-0.8.6.zip</a>                                 <i>( 4 MB)</i>
<a href="https://sourceforge.net/projects/gnuwin32/files/make/3.81/">make-3.81-bin.zip</a>                                <i>(10 MB)</i>
<a href="https://adoptopenjdk.net/?variant=openjdk11&jvmVariant=hotspot">OpenJDK11U-jdk_x64_windows_hotspot_11.0.8_10.zip</a> <i>(99 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.29.0-64-bit.7z.exe</a>                 <i>(41 MB)</i>
<a href="https://github.com/sbt/sbt/releases">sbt-1.4.1.zip</a>                                    <i>(55 MB)</i>
<a href="https://www.scala-lang.org/files/archive/">scala-2.13.3.zip</a>                                 <i>(21 MB)</i>
</pre>

<b name="footnote_04">[4]</b> ***PowerShell*** [↩](#anchor_04) <!-- 2018-05-09 -->

<p style="margin:0 0 1em 20px;"> 
Command Prompt has been around for as long as we can remember, but starting with Windows 10 build 14971, Microsoft is trying to make <a href="https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6">PowerShell</a> the <a href="https://support.microsoft.com/en-us/help/4027690/windows-powershell-is-replacing-command-prompt">main command shell</a> in the operating system.
</p>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/October 2020* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[apache_ant]: https://ant.apache.org/
[apache_ant_cli]: https://ant.apache.org/manual/running.html
[apache_ant_relnotes]: https://archive.apache.org/dist/ant/RELEASE-NOTES-1.10.9.html
[apache_maven]: https://maven.apache.org/download.cgi
[apache_maven_cli]: https://maven.apache.org/ref/current/maven-embedder/cli.html
[apache_maven_history]: https://maven.apache.org/docs/history.html
[apache_maven_relnotes]: https://maven.apache.org/docs/3.6.3/release-notes.html
[bazel_cli]: https://docs.bazel.build/versions/master/command-line-reference.html
[bazel_releases]: https://github.com/bazelbuild/bazel/releases
[bazel_relnotes]: https://github.com/bazelbuild/bazel/releases/tag/3.6.0
[bloop_releases]: https://scalacenter.github.io/bloop/
[bloop_relnotes]: https://github.com/scalacenter/bloop/releases/tag/v1.3.4
[cfr_releases]: https://www.benf.org/other/cfr/
[dotty]: https://dotty.epfl.ch
[dotty_metaprogramming]: https://dotty.epfl.ch/docs/reference/metaprogramming/toc.html
[dotty_nightly]: https://search.maven.org/search?q=g:ch.epfl.lamp
[dotty_releases]: https://github.com/lampepfl/dotty/releases
[dotty_relnotes]: https://github.com/lampepfl/dotty/releases/tag/0.27.0-RC1
[dotty_repl]: https://docs.scala-lang.org/overviews/repl/overview.html
[github_scala]: https://github.com/lampepfl/dotty/blob/master/dist/bin/scala
[git_bash]: https://www.atlassian.com/git/tutorials/git-bash
[git_cli]: https://git-scm.com/docs/git
[git_releases]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.29.0.txt
[github_guides]: https://guides.github.com/
[github_lampepfl_dotty]: https://github.com/lampepfl/dotty
[github_markdown]: https://github.github.com/gfm/
[github_PR5444]: https://github.com/lampepfl/dotty/pull/5444
[gmake_cli]: http://www.glue.umd.edu/lsf-docs/man/gmake.html
[make_downloads]: https://sourceforge.net/projects/gnuwin32/files/make/3.81/
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_compatibility]: https://docs.gradle.org/current/release-notes.html#upgrade-instructions
[gradle_install]: https://gradle.org/install/
[gradle_relnotes]: https://docs.gradle.org/6.7/release-notes.html
[haskell_examples]: https://github.com/michelou/haskell-examples
[jacoco_changelog]: https://www.jacoco.org/jacoco/trunk/doc/changes.html
[jacoco_downloads]: https://www.eclemma.org/jacoco/
[jar_file]: https://docs.oracle.com/javase/8/docs/technotes/guides/jar/jarGuide.html
[java_bytecode]: https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-6.html
[java_jls]: https://docs.oracle.com/javase/specs/jls/se8/html/index.html
[javac_cli]: https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.html
[javap_cli]: https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javap.html
[jmh]: https://openjdk.java.net/projects/code-tools/jmh/
[kotlin_examples]: https://github.com/michelou/kotlin-examples
[llvm_examples]: https://github.com/michelou/llvm-examples
[man1_awk]: https://www.linux.org/docs/man1/awk.html
[man1_diff]: https://www.linux.org/docs/man1/diff.html
[man1_file]: https://www.linux.org/docs/man1/file.html
[man1_grep]: https://www.linux.org/docs/man1/grep.html
[man1_more]: https://www.linux.org/docs/man1/more.html
[man1_mv]: https://www.linux.org/docs/man1/mv.html
[man1_rmdir]: https://www.linux.org/docs/man1/rmdir.html
[man1_sed]: https://www.linux.org/docs/man1/sed.html
[man1_wc]: https://www.linux.org/docs/man1/wc.html
[maven_lamp]: https://search.maven.org/search?q=g:ch.epfl.lamp
[microsoft_powershell]: https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6
[microsoft_vscode]: https://code.visualstudio.com/
[mill_changelog]: https://github.com/lihaoyi/mill#changelog
[mill_cli]: https://www.lihaoyi.com/mill/#command-line-tools
[mill_releases]: https://github.com/lihaoyi/mill/releases/
[nodejs_examples]: https://github.com/michelou/nodejs-examples
[oracle_openjdk]: https://adoptopenjdk.net/?variant=openjdk11&jvmVariant=hotspot
<!-- also: https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/tag/jdk8u252-b09 -->
[oracle_openjdk_relnotes]: https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2020-April/003019.html
<!--
[python_changelog]: https://docs.python.org/3.8/whatsnew/changelog.html#python-3-8-0-final
[python_release]: https://www.python.org/downloads/release/python-380/
-->
[sbt_cli]: https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html
[sbt_downloads]: https://github.com/sbt/sbt/releases
[sbt_libs]: https://www.scala-sbt.org/1.x/docs/Library-Dependencies.html
[sbt_relnotes]: https://github.com/sbt/sbt/releases/tag/v1.4.1
[sbt_server]: https://www.scala-sbt.org/1.x/docs/sbt-server.html
[scala]: https://www.scala-lang.org/
[scala_releases]: https://www.scala-lang.org/files/archive/
[scala_relnotes]: https://github.com/scala/scala/releases/tag/v2.13.3
[scalac_cli]: https://docs.scala-lang.org/overviews/compiler-options/index.html
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[unix_bash_script]: https://www.gnu.org/software/bash/manual/bash.html
[unix_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[windows_batch_file]: https://en.wikibooks.org/wiki/Windows_Batch_Scripting
[windows_installer]: https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-portal
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
