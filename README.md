# <span id="top">Running Dotty on Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:60px;max-width:100px;">
    <a href="http://dotty.epfl.ch/"><img style="border:0;" src="docs/dotty.png"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This repository gathers <a href="https://dotty.epfl.ch/">Dotty</a> code examples coming from various websites - mostly from the <a href="https://dotty.epfl.ch/">Dotty</a> project - or written by myself.<br/>
    In particular it includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a> for experimenting with the Dotty language (aka <a href="https://www.scala-lang.org/blog/2018/04/19/scala-3.html">Scala 3</a>) on a Windows machine.
  </td>
  </tr>
</table>

This document is part of a series of topics related to [Dotty](https://dotty.epfl.ch/) on Windows:

- Running Dotty on Windows [**&#9660;**](#bottom)
- [Building Dotty on Windows](BUILD.md)
- [Data Sharing and Dotty on Windows](CDS.md)
- [OpenJDK and Dotty on Windows](OPENJDK.md)

[JMH](https://openjdk.java.net/projects/code-tools/jmh/), [Metaprogramming](https://dotty.epfl.ch/docs/reference/metaprogramming/toc.html), [GraalVM](https://github.com/michelou/graalvm-examples) and [LLVM](https://github.com/michelou/llvm-examples) are other topics we are currently investigating.

## <span id="proj_deps">Project dependencies</span>

This project depends on two external software for the **Microsoft Windows** platform:

- [Dotty 0.20](https://github.com/lampepfl/dotty/releases) ([*release notes*](https://github.com/lampepfl/dotty/releases/tag/0.20.0-RC1))
- [Oracle OpenJDK 8](https://adoptopenjdk.net/?variant=openjdk8&jvmVariant=hotspot)<sup id="anchor_01">[[1]](#footnote_01)</sup> ([*release notes*](http://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-October/010452.html))
<!--
8u212 -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-April/009115.html
8u222 -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-July/009840.html
8u232 -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-October/010452.html
-->
Optionally one may also install the following software:

- [Apache Ant 1.10](https://ant.apache.org/) (requires Java 8) ([*release notes*](https://archive.apache.org/dist/ant/RELEASE-NOTES-1.10.7.html))
- [Apache Maven 3.6](http://maven.apache.org/download.cgi) ([requires Java 7](http://maven.apache.org/docs/history.html))  ([*release notes*](http://maven.apache.org/docs/3.6.1/release-notes.html))
- [Bloop 1.3](https://scalacenter.github.io/bloop/) (requires Java 8 and Python 2/3) ([*release notes*](https://github.com/scalacenter/bloop/releases/tag/v1.3.4))
- [CFR 0.14](http://www.benf.org/other/cfr/) (Java decompiler)
- [Git 2.24](https://git-scm.com/download/win) ([*release notes*](https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.24.0.txt))
- [Gradle 5.6](https://gradle.org/install/) ([requires Java 8 or newer](https://docs.gradle.org/current/release-notes.html#potential-breaking-changes)) ([*release notes*](https://docs.gradle.org/5.6.2/release-notes.html))
- [Mill 0.5](https://github.com/lihaoyi/mill/releases/) ([*change log*](https://github.com/lihaoyi/mill#changelog))
- [SBT 1.3](https://www.scala-sbt.org/download.html) (requires Java 8) ([*release notes*](https://github.com/sbt/sbt/releases/tag/v1.3.2))
- [Scala 2.13](https://www.scala-lang.org/files/archive/) (requires Java 8) ([*release notes*](https://github.com/scala/scala/releases/tag/v2.13.1))

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive](https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/) rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`](http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) directory on Unix).

For instance our development environment looks as follows (*November 2019*)<sup id="anchor_02">[[2]](#footnote_02)</sup>:

<pre style="font-size:80%;">
C:\opt\jdk-1.8.0_232-b09\    <i>(184.0 MB)</i>
C:\opt\apache-ant-1.10.7\    <i>( 39.9 MB)</i>
C:\opt\apache-maven-3.6.2\   <i>( 10.1 MB)</i>
C:\opt\bloop-1.3.4\          <i>(  0.1 MB)</i>
C:\opt\cfr-0.148\            <i>(  1.7 MB)</i>
C:\opt\dotty-0.20.0-RC1\     <i>( 25.2 MB)</i>
C:\opt\Git-2.24.0\           <i>(271.0 MB)</i>
C:\opt\gradle-5.6.4\         <i>(101.0 MB)</i>
C:\opt\Mill-0.5.2\           <i>( 49.0 MB)</i>
C:\opt\sbt-1.3.3\            <i>( 55.1 MB)</i>
C:\opt\scala-2.13.1\         <i>( 20.1 MB)</i>
</pre>

> **:mag_right:** [Git for Windows](https://gitforwindows.org/) provides a BASH emulation used to run [**`git`**](https://git-scm.com/docs/git) from the command line (as well as over 250 Unix commands like [**`awk`**](https://www.linux.org/docs/man1/awk.html), [**`diff`**](https://www.linux.org/docs/man1/diff.html), [**`file`**](https://www.linux.org/docs/man1/file.html), [**`grep`**](https://www.linux.org/docs/man1/grep.html), [**`more`**](https://www.linux.org/docs/man1/more.html), [**`mv`**](https://www.linux.org/docs/man1/mv.html), [**`rmdir`**](https://www.linux.org/docs/man1/rmdir.html), [**`sed`**](https://www.linux.org/docs/man1/sed.html) and [**`wc`**](https://www.linux.org/docs/man1/wc.html)).

## <span id="structure">Directory structure</span>

This project is organized as follows:

<pre style="font-size:80%;">
bin\*.bat
bin\cfr-0.148.zip
bin\0.20\*.bat
bin\dotty\
docs\
dotty\     <i>(Git submodule)</i>
examples\{dotty-example-project, ..}
myexamples\{00_AutoParamTupling, ..}
README.md
setenv.bat
</pre>

where

- directory [**`bin\`**](bin/) provides several utility batch commands.
- file [**`bin\cfr-0.148.zip`**](bin/cfr-0.148.zip) contains a zipped distribution of [CFR](http://www.benf.org/other/cfr/).
- directory [**`bin\0.20\`**](bin/0.20/) contains the batch commands for [Dotty 0.20](https://github.com/lampepfl/dotty/releases/tag/0.20.0-RC1).
- directory [**`bin\dotty\`**](bin/dotty/project/scripts/) contains several batch scripts for building the [Dotty](https://dotty.epfl.ch/) software distribution on a Windows machine.. 
- directory [**`docs\`**](docs/) contains [Dotty](https://dotty.epfl.ch/) related papers/articles.
- directory **`dotty\`** contains our fork of the [lampepfl/dotty](https://github.com/lampepfl/dotty) repository as a [Github submodule](.gitmodules).
- directory [**`examples\`**](examples/) contains [Dotty](https://dotty.epfl.ch/) examples grabbed from various websites.
- directory [**`myexamples\`**](myexamples/) contains self-written Dotty examples.
- file [**`README.md`**](README.md) is the [Markdown](https://github.github.com/gfm/) document for this page.
- file [**`setenv.bat`**](setenv.bat) is the batch command for setting up our environment.

> **:mag_right:** We use [VS Code](https://code.visualstudio.com/) with the extension [Markdown Preview Github Styling](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-preview-github-styles) to edit our Markdown files (see article ["Mastering Markdown"](https://guides.github.com/features/mastering-markdown/) from [GitHub Guides](https://guides.github.com/)).

We also define a virtual drive **`W:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"](https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation) from Microsoft Support).
> **:mag_right:** We use the Windows external command [**`subst`**](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst) to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; subst W: %USERPROFILE%\workspace\dotty-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## <span id="commands">Batch commands</span>

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](setenv.bat) - This batch command makes external tools such as [**`javac.exe`**](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.html), [**`scalac.bat`**](https://docs.scala-lang.org/overviews/compiler-options/index.html), [**`dotc.bat`**](bin/0.17/dotc.bat), etc. directly available from the command prompt (see section [**Project dependencies**](#proj_deps)).

   <pre style="font-size:80%;">
   <b>&gt; setenv help</b>
   Usage: setenv { &lt;option&gt; | &lt;subcommand&gt; }
   &nbsp;
     Options:
       -verbose         display environment settings
   &nbsp;
     Subcommands:
       help             display this help message
   </pre>

2. Directory [**`bin\`**](bin/) - This directory contains several utility batch files:
   - [**`cleanup.bat`**](bin/cleanup.bat) removes the generated class files from every example directory (both in [**`examples\`**](examples/) and [**`myexamples\`**](myexamples/) directories).
   - [**`dirsize.bat <dir_path_1> ..`**](bin/dirsize.bat) prints the size in Kb/Mb/Gb of the specified directory paths.
   - [**`getnightly.bat`**](bin/getnightly.bat) downloads/installs the library files from the latest [Dotty nightly build](https://search.maven.org/search?q=g:ch.epfl.lamp).
   - [**`searchjars.bat <class_name>`**](bin/searchjars.bat) searches for the given class name into all Dotty/Scala JAR files.
   - [**`timeit.bat <cmd_1> { & <cmd_2> }`**](bin/timeit.bat) prints the execution time of the specified commands.
   - [**`touch.bat <file_path>`**](bin/touch.bat) updates the modification date of an existing file or creates a new one.<div style="font-size:8px;">&nbsp;</div>

3. Directory [**`bin\0.20\`**](bin/0.20/) - This directory contains batch files to be copied to the **`bin\`** directory of the [Dotty](https://dotty.epfl.ch/) installation (eg. **`C:\opt\dotty-0.20.0-RC1\bin\`**) in order to use the [**`dotc`**](bin/0.20/dotc.bat), [**`dotd`**](bin/0.20/dotd.bat) and [**`dotr`**](bin/0.20/dotr.bat) commands on **Microsoft Windows**.
    > **&#9755;** We wrote (and do maintain) those batch files based on the bash scripts available from the official [Dotty distribution](https://github.com/lampepfl/dotty/releases). We also have submitted pull request [#5444](https://github.com/lampepfl/dotty/pull/5444) to add them to the Dotty distribution.

    <pre style="font-size:80%;">
    <b>&gt; dir /b c:\opt\dotty-0.20.0-RC1\bin</b>
    common
    common.bat
    dotc
    dotc.bat
    dotd
    dotd.bat
    dotr
    dotr.bat
    </pre>

<!-- ## removed on 2018-10-05 ##
    > **NB.** Prior to version 0.9-RC1 the [**`dotr`**](bin/0.9/dotr.bat) command did hang on Windows due to implementation issues with the Dotty [REPL](https://en.wikipedia.org/wiki/Read–eval–print_loop). This [issue](https://github.com/lampepfl/dotty/pull/4680) has been fixed by using [JLine 3](https://github.com/jline/jline3) in the REPL.
-->

4. File [**`bin\dotty\build.bat`**](bin/dotty/build.bat) - This batch command generates the [Dotty](https://dotty.epfl.ch) software distribution.

5. File [**`examples\*\build.bat`**](examples/dotty-example-project/build.bat) - Finally each example can be built/run using the [**`build`**](examples/dotty-example-project/build.bat) command.<br/>
    > **&#9755;** We prefer command [**`build`**](examples/dotty-example-project/build.bat) here since our code examples are simple and don't require the [**`sbt`** ](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html)machinery (eg. [library dependencies](https://www.scala-sbt.org/1.x/docs/Library-Dependencies.html), [sbt server](https://www.scala-sbt.org/1.x/docs/sbt-server.html)).

    <pre style="font-size:80%;">
    <b>&gt; build</b>
    Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
    &nbsp;
      Options:
        -debug           show commands executed by this script
        -explain         set compiler option -explain
        -explain-types   set compiler option -explain-types
        -compiler:&lt;name&gt; select compiler (scala|scalac|dotc|dotty), default:dotc
        -main:&lt;name&gt;     define main class name
        -tasty           compile both from source and TASTy files
        -timer           display the compile time
        -verbose         display progress messages
    &nbsp;
      Subcommands:
        clean            delete generated class files
        compile          compile source files (Java and Scala)
        doc              generate documentation
        help             display this help message
        run              execute main class
    &nbsp;
      Properties:
      (to be defined in SBT configuration file project\build.properties)
        compiler.cmd     alternative to option -compiler
        main.class       alternative to option -main
        main.args        list of arguments to be passed to main class
    </pre>

## Optional tools

1. Build tools

    Code examples in directories [**`examples\`**](examples/) and [**`myexamples\`**](myexamples/) can also be built with the following tools as an alternative to the **`build`** command (see [**`examples\README`**](examples/README.md) and [**`myexamples\README`**](myexamples/README.md) for more details):

    | **Build tool** | **Config file** | **Parent file** | **Usage example** |
    | :------------: | :-------------: | :-------------: | :---------------- |
    | [**`ant`**](https://ant.apache.org/manual/running.html) | [**`build.xml`**](examples/enum-Planet/build.xml) | [**`build.xml`**](examples/build.xml) | **`ant clean compile run`** |
    | [**`bloop`**](https://www.scala-sbt.org/) | &empty; | &empty; | &empty; |
    | [**`gradle`**](https://docs.gradle.org/current/userguide/command_line_interface.html) | [**`build.gradle`**](examples/enum-Planet/build.gradle) | [**`common.gradle`**](examples/common.gradle) | **`gradle clean build run`** |
    | [**`mill`**](http://www.lihaoyi.com/mill/#command-line-tools) | [**`build.sc`**](examples/enum-Planet/build.sc) | &empty; | **`mill -i go`** |
    | [**`mvn`**](https://maven.apache.org/ref/3.6.2/maven-embedder/cli.html) | [**`pom.xml`**](examples/enum-Planet/pom.xml) | [**`pom.xml`**](examples/pom.xml) | **`mvn clean compile test`** |
    | [**`sbt`**](https://www.scala-sbt.org/) | [**`build.sbt`**](examples/enum-Planet/build.sbt) | &empty; | **`sbt clean compile run`** |

2. Decompiler tools

    As an alternative to the standard [**`javap`**](https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javap.html) class decompiler one may use **`cfr.bat`** (simply extract [**`bin\cfr-0.148.zip`**](bin/cfr-0.148.zip) to **`c:\opt\`**) which prints [Java source code](https://docs.oracle.com/javase/specs/jls/se8/html/index.html) instead of [Java bytecode](https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-6.html):

    <pre style="font-size:80%;">
    <b>&gt; cfr myexamples\00_AutoParamTupling\target\classes\myexamples\Main.class</b>
    /*
     * Decompiled with CFR 0.148.
     */
    package myexamples;
    
    import myexamples.Main$;
    
    public final class Main {
        public static void test01() {
            Main$.MODULE$.test01();
        }
    
        public static void main(String[] arrstring) {
            Main$.MODULE$.main(arrstring);
        }
    
        public static void test02() {
            Main$.MODULE$.test02();
        }
    }
    </pre>

    Here is the console output from command [**`javap`**](https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javap.html) with option **`-c`** for the same class file:

    <pre style="font-size:80%;">
    <b>&gt; javap -c myexamples\00_AutoParamTupling\target\classes\myexamples\Main.class</b>
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

## <span id="usage">Usage examples</span>

#### `setenv.bat`

Command [**`setenv`**](setenv.bat) is executed once to setup our development environment; it makes external tools such as [**`javac.exe`**](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.html), [**`sbt.bat`**](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html) and [**`git.exe`**](https://git-scm.com/docs/git) directly available from the command prompt:

<pre style="font-size:80%;">
<b>&gt; setenv</b>
Tool versions:
   javac 1.8.0_232, java 1.8.0_232, scalac 2.13.1, dotc 0.20.0-RC1,
   ant 1.10.7, gradle 5.6.4, mill 0.5.2, mvn 3.6.2, sbt 1.3.3/2.12.8,
   cfr 0.148, bloop v1.3.4, git 2.24.0.windows.1, diff 3.7

<b>&gt; where sbt</b>
C:\opt\sbt-1.3.3\bin\sbt
C:\opt\sbt-1.3.3\bin\sbt.bat
</pre>

Command [**`setenv -verbose`**](setenv.bat) also displays the tool paths:

<pre style="font-size:80%;">
<b>&gt; setenv -verbose</b>
Tool versions:
   javac 1.8.0_232, java 1.8.0_232, scalac 2.13.1, dotc 0.20.0-RC1,
   ant 1.10.7, gradle 5.6.4, mill 0.5.2, mvn 3.6.2, sbt 1.3.3/2.12.8,
   cfr 0.148, bloop v1.3.4, git 2.24.0.windows.1, diff 3.7
Tool paths:
   C:\opt\jdk-1.8.0_232-b09\bin\javac.exe
   C:\opt\jdk-1.8.0_232-b09\bin\java.exe
   C:\ProgramData\Oracle\Java\javapath\java.exe
   C:\Program Files (x86)\Common Files\Oracle\Java\javapath\java.exe
   C:\opt\scala-2.13.1\bin\scalac.bat
   C:\opt\dotty-0.20.0-RC1\bin\dotc.bat
   C:\opt\apache-ant-1.10.7\bin\ant.bat
   C:\opt\gradle-5.6.4\bin\gradle.bat
   C:\opt\Mill-0.5.2\mill.bat
   C:\opt\apache-maven-3.6.2\bin\mvn.cmd
   C:\opt\sbt-1.3.3\bin\sbt.bat
   C:\opt\cfr-0.148\bin\cfr.bat
   C:\opt\bloop-1.3.4\bloop.cmd
   C:\opt\Git-2.24.0\bin\git.exe
   C:\opt\Git-2.24.0\usr\bin\diff.exe
</pre>

#### `cleanup.bat`

Command [**`cleanup`**](bin/cleanup.bat) removes the output directories (ie. **`target\`**) from the example projects: 

<pre style="font-size:80%;">
<b>&gt; cleanup</b>
Finished to clean up 2 subdirectories in W:\dotty\cdsexamples
Finished to clean up 16 subdirectories in W:\dotty\examples
Finished to clean up 12 subdirectories in W:\dotty\myexamples
</pre>

#### `dirsize.bat {<dir_name>}`

Command [**`dirsize`**](bin/dirsize.bat) returns the size (in Kb, Mb or Gb) of the specified directory paths:

<pre style="font-size:80%;">
<b>&gt; dirsize examples myexamples c:\opt\dotty-0.20.0-RC1 c:\opt\jdk-1.8.0_232-b09</b>
Size of directory "examples" is 3.9 Mb
Size of directory "myexamples" is 1.2 Mb
Size of directory "c:\opt\dotty-0.20.0-RC1" is 25.2 Mb
Size of directory "c:\opt\jdk-1.8.0_232-b09" is 184.1 Mb
</pre>

#### `getnightly.bat`

By default command [**`getnightly`**](bin/getnightly.bat) downloads the library files of the latest [Dotty nightly build](https://search.maven.org/search?q=g:ch.epfl.lamp) available from the [Maven Central Repository](https://search.maven.org/search?q=g:ch.epfl.lamp) and saves them into directory **`out\nightly-jars\`**.

<pre style="font-size:80%;">
<b>&gt; getnightly</b>

<b>&gt; dir /b out\nightly-jars</b>
dotty-compiler_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
dotty-doc_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
dotty-interfaces-0.21.0-bin-20191101-3939747-NIGHTLY.jar
dotty-language-server_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
dotty-library_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
dotty-sbt-bridge-0.21.0-bin-20191101-3939747-NIGHTLY.jar
dotty-staging_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
dotty_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
</pre>

Command [**`getnightly -verbose`**](bin/getnightly.bat) also displays the download progress:

<pre style="font-size:80%">
<b>&gt; getnightly -verbose</b>
Downloading file dotty_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar ... 0.3 Kb
Downloading file dotty-language-server_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar ... 146.3 Kb
Downloading file dotty-sbt-bridge-0.21.0-bin-20191101-3939747-NIGHTLY.jar ... 13.4 Kb
Downloading file dotty-interfaces-0.21.0-bin-20191101-3939747-NIGHTLY.jar ... 3.4 Kb
Downloading file dotty-library_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar ... 1.3 Mb
Downloading file dotty-compiler_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar ... 11.2 Mb
Downloading file dotty-staging_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar ... 36.7 Kb
Downloading file dotty-doc_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar ... 1 Mb
Finished to download 8 files to directory W:\DOTTY-~1\out\nightly-jars
</pre>

We can now replace the library files from the original [Dotty distribution](https://github.com/lampepfl/dotty/releases) (installed in directory **`C:\opt\dotty-0.20.0-RC1\`** in our case) with library files from the latest nightly build.

Concretely, we specify the **`activate`** subcommand to switch to the nightly build version and the **`reset`** subcommand to restore the original library files in the [Dotty](https://dotty.epfl.ch) installation directory.

<pre style="font-size:80%;">
<b>&gt; getnightly activate</b>
Finished to download 8 files to directory W:\out\nightly-jars
Activate nightly build libraries: 0.21.0-bin-20191101-3939747-NIGHTLY

<b>&gt; dotc -version</b>
Dotty compiler version 0.21.0-bin-20191101-3939747-NIGHTLY-git-3939747 -- Copyright 2002-2019, LAMP/EPFL

<b>&gt; getnightly reset</b>
Activate default Dotty libraries: 0.20.0-RC1

<b>&gt; dotc -version</b>
Dotty compiler version 0.20.0-RC1 -- Copyright 2002-2019, LAMP/EPFL
</pre>

> **:warning:** You need *write access* to the [Dotty](https://dotty.epfl.ch) installation directory (e.g. **`C:\opt\dotty-0.20.0-RC1\`** in our case) in order to successfully run the **`activate/reset`** subcommands.

Internally command [**`getnightly`**](bin/getnightly.bat) manages two sets of libraries files which are organized as follows:

<pre style="font-size:80%;">
<b>&gt; pushd c:\opt\dotty-0.20.0-RC1&dir/b/a-d&for /f %i in ('dir/s/b/ad lib') do @(echo lib\%~nxi\&dir/b %i)&popd</b>
VERSION
VERSION-NIGHTLY
lib\0.20.0-RC1\
&nbsp;&nbsp;dist_0.20-0.20.0-RC1.jar
&nbsp;&nbsp;dotty-compiler_0.20-0.20.0-RC1.jar
&nbsp;&nbsp;dotty-doc_0.20-0.20.0-RC1.jar
&nbsp;&nbsp;dotty-interfaces-0.20.0-RC1.jar
&nbsp;&nbsp;dotty-library_0.20-0.20.0-RC1.jar
&nbsp;&nbsp;dotty-staging_0.20-0.20.0-RC1.jar
lib\0.21.0-bin-20191101-3939747-NIGHTLY\
&nbsp;&nbsp;dotty-compiler_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
&nbsp;&nbsp;dotty-doc_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
&nbsp;&nbsp;dotty-interfaces-0.21.0-bin-20191101-3939747-NIGHTLY.jar
&nbsp;&nbsp;dotty-language-server_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
&nbsp;&nbsp;dotty-library_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
&nbsp;&nbsp;dotty-sbt-bridge-0.21.0-bin-20191101-3939747-NIGHTLY.jar
&nbsp;&nbsp;dotty-staging_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
&nbsp;&nbsp;dotty_0.21-0.21.0-bin-20191101-3939747-NIGHTLY.jar
</pre>

In the above output file **`VERSION-NIGHTLY`** contains the signature of the managed nightly build and the **`lib\`** directory contains two backup directories with copies of the library files from the original [Dotty](https://dotty.epfl.ch) installation respectively from the latest nightly build.

> **:mag_right:** Dotty versions up to `0.18.0` depend on **`scala-library-2.12.8.jar`**; Dotty versions `0.18.1` and newer depend on **`scala-library-2.13.x.jar`**.


#### `searchjars.bat <class_name>`

Command **`searchjars`** helps us to search for class file names in the following directories: project's **`lib\`** directory (*if present*), Dotty's **`lib\`** directory, Java's **`lib\`** directory and Ivy/Maven default directories.

<pre style="font-size:80%;">
<b>&gt; searchjars -help</b>
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

Passing argument **`System`** to command [**`searchjars`**](bin/searchjars.bat) prints the following output (class file names are printed with full path and are prefixed with their containing [JAR file](https://docs.oracle.com/javase/8/docs/technotes/guides/jar/jarGuide.html)):

<pre style="font-size:80%;">
<b>&gt; searchjars System</b>
Searching for class System in library files C:\opt\DOTTY-~1.1-R\lib\*.jar
  scala-library-2.13.1.jar:scala/sys/SystemProperties$.class
  scala-library-2.13.1.jar:scala/sys/SystemProperties.class
Searching for class System in library files C:\opt\SCALA-~1.0\lib\*.jar
  scala-compiler.jar:scala/tools/util/SystemExit$.class
  scala-compiler.jar:scala/tools/util/SystemExit.class
  scala-library.jar:scala/sys/SystemProperties$.class
  scala-library.jar:scala/sys/SystemProperties.class
Searching for class System in library files C:\opt\JDK-18~1.0_2\lib\*.jar
  sa-jdi.jar:sun/jvm/hotspot/memory/SystemDictionary$1.class
  sa-jdi.jar:sun/jvm/hotspot/memory/SystemDictionary$2.class
  sa-jdi.jar:sun/jvm/hotspot/memory/SystemDictionary$ClassAndLoaderVisitor.class
  sa-jdi.jar:sun/jvm/hotspot/memory/SystemDictionary$ClassVisitor.class
  sa-jdi.jar:sun/jvm/hotspot/memory/SystemDictionary.class
  sa-jdi.jar:sun/jvm/hotspot/utilities/SystemDictionaryHelper$1.class
  sa-jdi.jar:sun/jvm/hotspot/utilities/SystemDictionaryHelper$2.class
  sa-jdi.jar:sun/jvm/hotspot/utilities/SystemDictionaryHelper$3.class
  sa-jdi.jar:sun/jvm/hotspot/utilities/SystemDictionaryHelper.class
Searching for class System in library files W:\lib\*.jar
</pre>

Searching for an unknown class - e.g. **`BinarySearch`** - produces the following output:

<pre style="font-size:80%;">
<b>&gt; searchjars BinarySearch</b>
Searching for class BinarySearch in library files C:\opt\DOTTY-~1.1-R\lib\*.jar
Searching for class BinarySearch in library files C:\opt\SCALA-~1.0\lib\*.jar
Searching for class BinarySearch in library files C:\opt\JDK-18~1.0_2\lib\*.jar
Searching for class BinarySearch in library files W:\lib\*.jar
</pre>

Searching for **`FileSystem`** with option **`-artifact`** produces the following output:

<pre style="font-size:80%;">
<b>&gt; searchjars FileSystem -artifact</b>
Searching for class FileSystem in library files C:\opt\DOTTY-~1.1-R\lib\*.jar
Searching for class FileSystem in library files C:\opt\SCALA-~1.0\lib\*.jar
Searching for class FileSystem in library files C:\opt\JDK-18~1.0_2\lib\*.jar
Searching for class FileSystem in library files W:\\lib\*.jar
Searching for class FileSystem in library files %USERPROFILE%\.ivy2\cache\*.jar
  jimfs-1.1.jar:com/google/common/jimfs/FileSystemState.class
  jimfs-1.1.jar:com/google/common/jimfs/FileSystemView$1.class
  [...]
  okhttp-3.7.0.jar:okhttp3/internal/io/FileSystem$1.class
  okhttp-3.7.0.jar:okhttp3/internal/io/FileSystem.class
  org.eclipse.lsp4j-0.5.0.jar:org/eclipse/lsp4j/FileSystemWatcher.class
  org.eclipse.xtend.lib.macro-2.16.0.jar:org/eclipse/xtend/lib/macro/file/FileSystemSupport.class
  org.eclipse.xtend.lib.macro-2.16.0.jar:org/eclipse/xtend/lib/macro/file/MutableFileSystemSupport.class
  jmh-core-1.19.jar:org/openjdk/jmh/generators/core/FileSystemDestination.class
  jmh-core-1.21.jar:org/openjdk/jmh/generators/core/FileSystemDestination.class
  ivy-2.3.0-sbt-b18f59ea3bc914a297bb6f1a4f7fb0ace399e310.jar:org/apache/ivy/plugins/resolver/FileSystemResolver.class
  ivy-2.3.0-sbt-cb9cc189e9f3af519f9f102e6c5d446488ff6832.jar:org/apache/ivy/plugins/resolver/FileSystemResolver.class
Searching for class FileSystem in library files %USERPROFILE%\.m2\repository\*.jar
  commons-io-2.2.jar:org/apache/commons/io/FileSystemUtils.class
  commons-io-2.5.jar:org/apache/commons/io/FileSystemUtils.class
  commons-io-2.6.jar:org/apache/commons/io/FileSystemUtils.class
  ivy-2.4.0.jar:org/apache/ivy/plugins/resolver/FileSystemResolver.class
  sigar-1.6.4.jar:org/hyperic/sigar/FileSystem.class
  [...]
  stagemonitor-os-0.88.9.jar:org/stagemonitor/os/metrics/FileSystemMetricSet.class
</pre>

#### `timeit.bat <cmd_1> { & <cmd_i> }`

Command [**`timeit`**](bin/timeit.bat) prints the execution time (`hh:MM:ss` format) of the specified command (possibly given with options and parameters):

<pre style="font-size:80%;">
<b>&gt; timeit dir /b</b>
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
<b>&gt; timeit build clean compile</b>
Execution time: 00:00:08
</pre>

Chaining of commands is also possible. Note that the command separator (either **`&&`** or **`&`**) must be escaped if the command chain is not quoted. For instance:

<pre style="font-size:80%;">
<b>&gt; timeit build clean compile ^&^& ant run</b>
...
Execution time: 00:00:11
<b>&gt; timeit "build clean compile && ant run"</b>
...
Execution time: 00:00:11
</pre>

> **:mag_right:** The **`&&`** command separator performs error checking - that is, the commands to the right of the **`&&`** command run ***if and only if*** the command to the left of **`&&`** succeeds. The **`&`** command ***does not*** perform error checking - that is, all commands run.

<!--
#### `touch.bat`

The [**`touch.bat`**](bin/touch.bat) command


#### `updateprojs`

Command [**`updateprojs`**](bin/updateprojs.bat) updates the following software versions:

| Project file | Variable | Example |
| :----------- | :------: | :------ |
| `build.sbt` | `dottyVersion` | `0.18.1-RC1` &rarr; `0.20.0-RC1`|
| `build.sc` | `scalaVersion` | `0.18.1-RC1` &rarr; `0.20.0-RC1` |
| `project\build.properties` | `sbt.version` | `1.3.0` &rarr; `1.3.2` |
| `project\plugins.sbt` | `sbt-dotty` | `0.3.3` &rarr; `0.3.4` |

> **:construction:** Currently we have to edit the value pairs (old/new) directly in the batch file.

<pre style="margin:10px 0 0 30px;font-size:80%;">
<b>&gt; updateprojs</b>
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

#### `build.bat`

Command [**`build`**](examples/enum-Planet/build.bat) is a basic build tool consisting of ~400 lines of batch/[Powershell ](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) code <sup id="anchor_03">[[3]](#footnote_03)</sup>.

Running command [**`build`**](examples/enum-Planet/build.bat) with ***no*** option in project [**`examples\enum-Planet`**](examples/enum-Planet/) generates the following output:

<pre style="font-size:80%;">
<b>&gt; build clean compile run</b>
Your weight on MERCURY (0) is 0.37775761520093526
Your weight on SATURN (5) is 1.0660155388115666
Your weight on VENUS (1) is 0.9049990998410455
Your weight on URANUS (6) is 0.9051271993894251
Your weight on EARTH (2) is 0.9999999999999999
Your weight on NEPTUNE (7) is 1.1383280724696578
Your weight on MARS (3) is 0.37873718403712886
Your weight on JUPITER (4) is 2.5305575254957406</pre>

More usage examples are presented in [**`examples\README.md`**](examples/README.md) resp. [**`myexamples\README.md`**](myexamples/README.md)


#### `dotr.bat`

[Dotty REPL](https://docs.scala-lang.org/overviews/repl/overview.html) is an interactive tool for evaluating Scala expressions. Internally, it executes a source script by wrapping it in a template and then compiling and executing the resulting program.

   > **:warning:** Batch file [**`dotr.bat`**](bin/0.14/dotr.bat) is based on the bash script [**`dotr`**](https://github.com/lampepfl/dotty/blob/master/dist/bin/dotr) available from the standard [Dotty distribution](https://github.com/lampepfl/dotty/releases). We also have submitted pull request [#5444](https://github.com/lampepfl/dotty/pull/5444) to add that batch file to the Scala distribution.

<pre style="font-size:80%;">
<b>&gt; where dotr</b>
C:\opt\dotty-0.20.0-RC1\bin\dotr
C:\opt\dotty-0.20.0-RC1\bin\dotr.bat

<b>&gt; dotr -version</b>
openjdk version "1.8.0_232"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_232-b09)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.232-b09, mixed mode)

<b>&gt; dotr</b>
Starting dotty REPL...
scala> :help
The REPL has several commands available:

:help                    print this summary
:load &lt;path&gt;             interpret lines in a file
:quit                    exit the interpreter
:type &lt;expression&gt;       evaluate the type of the given expression
:imports                 show import history
:reset                   reset the repl to its initial state, forgetting all session entries

<b>scala&gt;</b> System.getenv().get("JAVA_HOME")
val res0: String = C:\opt\jdk-1.8.0_232-b09

<b>scala&gt;</b> System.getenv().get("DOTTY_HOME")
val res1: String = C:\opt\dotty-0.20.0-RC1

<b>scala&gt;</b> :load myexamples/HelloWorld/src/main/scala/HelloWorld.scala
// defined object HelloWorld

<b>scala&gt;</b> HelloWorld.main(Array())
Hello world!

<b>scala&gt;</b>:quit
</pre>

## <span id="footnotes">Footnotes</span>

<!-- ## removed on 2018-11-23 ##
<a name="footnote_01">[1]</a> ***2018-07-07*** [↩](#anchor_02)

<div style="margin:0 0 0 20px;">
Version 0.9 of the Dotty compiler is not compatible with versions 9 and 10 of <a href="https://docs.oracle.com/javase/9/install/overview-jdk-9-and-jre-9-installation.htm">Java JRE</a>; a <strong><code>java.lang.IncompatibleClassChangeError</code></strong> exception is thrown when starting the <strong><code>dotc</code></strong> command:
</div>
-->

<!--
C:\opt\jdk-11.0.1\bin\java.exe -Xmx768m -Xms768m -classpath C:\opt\dotty-0.9.0\lib\scala-library-2.12.6.jar;C:\opt\dotty-0.9.0\lib\scala-xml_2.12-1.1.0.jar;C:\opt\dotty-0.9.0\lib\scala-asm-6.0.0-scala-1.jar;C:\opt\dotty-0.9.0\lib\compiler-interface-1.1.6.jar;C:\opt\dotty-0.9.0\lib\dotty-interfaces-0.9.0.jar;C:\opt\dotty-0.9.0\lib\dotty-library_0.9-0.9.0.jar;C:\opt\dotty-0.9.0\lib\dotty-compiler_0.9-0.9.0.jar -Dscala.usejavacp=true dotty.tools.dotc.Main

C:\opt\jdk-11.0.1\bin\java.exe -Xmx768m -Xms768m -classpath C:\opt\dotty-0.17.0-RC1\lib\scala-library-2.12.8.jar;C:\opt\dotty-0.17.0-RC1\lib\scala-xml_2.12-1.1.0.jar;C:\opt\dotty-0.14.0-RC1\lib\scala-asm-6.0.0-scala-1.jar;C:\opt\dotty-0.17.0-RC1\lib\compiler-interface-1.2.2.jar;C:\opt\dotty-0.17.0-RC1\lib\dotty-interfaces-0.17.0-RC1.jar;C:\opt\dotty-0.17.0-RC1\lib\dotty-library_0.17-0.17.0-RC1.jar;C:\opt\dotty-0.17.0-RC1\lib\dotty-compiler_0.17-0.17.0-RC1.jar -Dscala.usejavacp=true dotty.tools.dotc.Main
-->

<!--
<pre style="font-size:80%;">
<b>&gt;</b> C:\Progra~1\Java\jre-10.0.2\bin\java.exe -Xmx768m -Xms768m \
-classpath C:\opt\dotty-0.9.0\lib\scala-library-2.12.6.jar; \
C:\opt\dotty-0.9.0\lib\scala-xml_2.12-1.1.0.jar; \
C:\opt\dotty-0.9.0\lib\scala-asm-6.0.0-scala-1.jar; \
C:\opt\dotty-0.9.0\lib\compiler-interface-1.1.6.jar; \
C:\opt\dotty-0.9.0\lib\dotty-interfaces-0.9.0.jar; \
C:\opt\dotty-0.9.0\lib\dotty-library_0.9-0.9.0.jar; \
C:\opt\dotty-0.9.0\lib\dotty-compiler_0.9-0.9.0.jar \
-Dscala.usejavacp=true dotty.tools.dotc.Main
Exception in thread "main" java.lang.IncompatibleClassChangeError: Method dotty.tools.dotc.core.Phases$PhasesBase.dotty$tools$dotc$core$Phases$PhasesBase$$initial$myTyperPhase()Ldotty/tools/dotc/core/Phases$Phase; must be InterfaceMethodref constant
        at dotty.tools.dotc.core.Contexts$ContextBase.<init>(Contexts.scala:544)
        at dotty.tools.dotc.Driver.initCtx(Driver.scala:41)
        at dotty.tools.dotc.Driver.process(Driver.scala:98)
        at dotty.tools.dotc.Driver.process(Driver.scala:115)
        at dotty.tools.dotc.Driver.main(Driver.scala:142)
        at dotty.tools.dotc.Main.main(Main.scala)
</pre>
-->

<a name="footnote_01">[1]</a> ***Java LTS*** [↩](#anchor_01) <!-- 2018-11-18 -->

<p style="margin:0 0 1em 20px;">
Oracle annonces in his <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">Java SE Support Roadmap</a> he will stop public updates of Java SE 8 for commercial use after January 2019. Launched in March 2014 Java SE 8 is classified an <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">LTS</a> release in the new time-based system and <a href="https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html">Java SE 11</a>, released in September 2018, is the current LTS release.
</p>

<a name="footnote_02">[2]</a> ***Downloads*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
In our case we downloaded the following installation files (<a href="#proj_deps">see section 1</a>):
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<a href="https://github.com/lampepfl/dotty/releases/tag/0.20.0-RC1">dotty-0.20.0-RC1.zip</a>                            <i>( 23 MB)</i>
<a href="">OpenJDK8U-jdk_x64_windows_hotspot_8u232b09.zip</a>  <i>( 99 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.24.0-64-bit.7z.exe</a>                <i>( 41 MB)</i>
</pre>

<a name="footnote_03">[3]</a> ***PowerShell*** [↩](#anchor_03) <!-- 2018-05-09 -->

<p style="margin:0 0 1em 20px;"> 
Command Prompt has been around for as long as we can remember, but starting with Windows 10 build 14971, Microsoft is trying to make <a href="https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6">PowerShell</a> the <a href="https://support.microsoft.com/en-us/help/4027690/windows-powershell-is-replacing-command-prompt">main command shell</a> in the operating system.
</p>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/November 2019* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>
