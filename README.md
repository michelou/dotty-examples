# <span id="top">Playing with Scala 3 on Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:60px;max-width:100px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;" src="docs/images/dotty.png" alt="Dotty project"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This repository gathers <a href="https://dotty.epfl.ch/" rel="external">Scala 3</a> code examples coming from various websites - mostly from the <a href="https://dotty.epfl.ch/" rel="external">Dotty</a> project - or written by myself.<br/>
    In particular it includes build scripts (<a href="https://ant.apache.org/manual/using.html" rel="external">Ant files</a>, <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_02_01.html" rel="external">Bash scripts</a>, <a href="https://docs.gradle.org/current/userguide/tutorial_using_tasks.html" rel="external">Gradle scripts</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>, <a href="https://maven.apache.org/guides/introduction/introduction-to-the-pom.html" rel="external">Maven scripts</a> and more) for experimenting with the <a href="https://www.scala-lang.org/blog/2018/04/19/scala-3.html" rel="external">Scala 3</a> language on a Windows machine.
  </td>
  </tr>
</table>

This document is part of a series of topics related to [Scala 3][scala3_home] on Windows:

- Running Scala 3 on Windows [**&#9660;**](#bottom)
- [Building Scala 3 on Windows](BUILD.md)
- [Data Sharing and Scala 3 on Windows](CDS.md)
- [OpenJDK and Scala 3 on Windows](OPENJDK.md)

[Ada][ada_examples], [Akka][akka_examples], [C++][cpp_examples], [Deno][deno_examples], [Flix][flix_examples], [Golang][golang_examples], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Spark][spark_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples] and [WiX Toolset][wix_examples] are other trending topics we are continuously monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on the following external software for the **Microsoft Windows** platform:

- [Git 2.38][git_releases] ([*release notes*][git_relnotes])
- [Scala 3.2][scala3_releases] ([*release notes*][scala3_relnotes])
- [Temurin OpenJDK 11 LTS][temurin_opendjk11] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][temurin_opendjk11_relnotes], [*bug fixes*][temurin_opendjk11_bugfixes])
- [Temurin OpenJDK 17 LTS][temurin_opendjk17] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][temurin_opendjk17_relnotes], [*bug fixes*][temurin_opendjk17_bugfixes])
<!--
8u212   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-April/009115.html
8u222   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-July/009840.html
8u232   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-October/010452.html
8u242   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2020-January/010979.html
8u252   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2020-April/011559.html
8u262   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2020-July/012143.html
8u272   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2020-October/012817.html
8u282   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2021-January/013337.html
8u292   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2021-April/013680.html
8u302   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2021-July/014118.html
8u322   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2022-January/014522.html
11.0.3  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2019-April/000951.html
11.0.4  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2019-July/001423.html
11.0.5  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2019-October/002025.html
11.0.6  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2020-January/002374.html
11.0.7  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2020-April/003019.html
11.0.8  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2020-July/003498.html
11.0.9  -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2020-October/004007.html
11.0.10 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-January/004689.html
11.0.11 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-April/005860.html
11.0.12 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-July/006954.html
11.0.13 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-October/009368.html
11.0.14 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2022-January/011643.html
11.0.15 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2022-April/014104.html
11.0.16 -> https://mail.openjdk.org/pipermail/jdk-updates-dev/2022-July/016017.html
-->
Optionally one may also install the following software:

- [Apache Ant 1.10][apache_ant] (requires Java 8) ([*release notes*][apache_ant_relnotes])
- [Apache Maven 3.8][apache_maven] ([requires Java 7][apache_maven_history])  ([*release notes*][apache_maven_relnotes])
- [Bazel 5.3][bazel_releases] <sup id="anchor_02">[2](#footnote_02)</sup> ([*release notes*][bazel_relnotes])
- [CFR 0.15][cfr_releases] (Java decompiler)
- [GNU Make 3.81][make_downloads]
- [Gradle 7.6][gradle_install] ([requires Java 8 or newer][gradle_compatibility]) ([*release notes*][gradle_relnotes])
- [JaCoCo 0.8][jacoco_downloads] <sup id="anchor_03">[3](#footnote_03)</sup> ([*change log*][jacoco_changelog])
- [JavaFX 17 LTS][javafx_downloads] ([*release notes*][javafx_relnotes])
- [JITWatch 1.4][jitwatch_releases] (requires Java 11 or newer)
- [Mill 0.10][mill_releases] ([*change log*][mill_changelog])
- [MSYS2][msys2_releases] ([*change log*][msys2_changelog])
- [sbt 1.8][sbt_downloads] (requires Java 8) ([*release notes*][sbt_relnotes])
- [Scala 2.13][scala_releases] (requires Java 8) ([*release notes*][scala_relnotes])
- [Temurin OpenJDK 8 LTS][temurin_openjdk8] <sup id="anchor_01">[1](#footnote_01)</sup> ([*release notes*][temurin_openjdk8_relnotes])
<!--
- [Bloop 1.5][bloop_releases] (requires Java 8 and Python 2/3) ([*release notes*][bloop_relnotes])
- [Python 3.8][python_release] ([*change log*][python_changelog])
-->

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a [Windows installer][windows_installer]. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][unix_opt] directory on Unix).

For instance our development environment looks as follows (*November 2022*) <sup id="anchor_04">[4](#footnote_04)</sup>:

<pre style="font-size:80%;">
C:\opt\apache-ant-1.10.12\         <i>( 40 MB)</i>
C:\opt\apache-maven-3.8.6\         <i>( 10 MB)</i>
C:\opt\bazel-5.3.2\                <i>( 44 MB)</i>
C:\opt\cfr-0.152\                  <i>(  2 MB)</i>
C:\opt\Git-2.38.1\                 <i>(317 MB)</i>
C:\opt\gradle-7.5.1\               <i>(122 MB)</i>
C:\opt\jacoco-0.8.8\               <i>( 10 MB)</i>
C:\opt\javafx-sdk-17.0.2\          <i>( 82 MB)</i>
C:\opt\jdk-temurin-1.8.0_345-b01\  <i>(185 MB)</i>
C:\opt\jdk-temurin-11.0.17_8\      <i>(301 MB)</i>
C:\opt\jdk-temurin-17.0.5_8\       <i>(299 MB)</i>
C:\opt\jitwatch-1.4.7\             <i>( 36 MB)</i>
C:\opt\make-3.81\                  <i>(  2 MB)</i>
C:\opt\mill-0.10.9\                <i>( 67 MB)</i>
C:\opt\msys64\                     <i>(5.5 GB)</i>
C:\opt\sbt-1.7.3\                  <i>( 50 MB)</i>
C:\opt\scala-2.13.10\              <i>( 24 MB)</i>
C:\opt\scala3-3.2.1\               <i>( 35 MB)</i>
</pre>
 <!-- jdk8: 242-b08 = 184 MB, 252-b09 = 181 MB , 262-b10 = 184 MB -->
 <!-- jdk8: 345-b01 = 186 MB -->
 <!-- jdk11: 11.0.8 = 314 MB, 11.0.9 = 316 MB, 11.0.11 = 300 MB -->
 <!-- jdk11: 11.0.16 = 301 MB, 11.0.17 = 301 MB -->
 <!-- sbt: 1.3.6 = 55.1 MB, 1.3.7 = 60.9 MB, 1.3.8 = 61.0 MB -->
 <!-- sbt: 1.3.9 = 61.2 MB, 1.3.10 = 61.2 MB, 1.3.11 = 61.3 MB, 1.4.1 = 47.6 MB -->
 <!-- sbt: 1.4.2 = 47.7 MB, 1.4.3 = 47.7 MB, 1.4.6 -> 48 MB, 1.4.6 = MB -->
 <!-- sbt: 1.4.7 = 48.3 MB, 1.4.8 = 48.3 MB, 1.5.0 = 48.3 MB -->
 <!-- sbt: 1.5.1 to 1.5.5 = 50.6 MB -->
 <!-- sbt: 1.6.1 = 50.6 MB, 1.6.2 = 50.6 MB -->
 <!-- sbt: 1.7.1 = 80.6 MB, 1.7.2 = 80.6 MB, 1.7.3 = 80.6 MB -->

> **:mag_right:** [Git for Windows][git_releases] provides a Bash emulation used to run [**`git.exe`**][git_cli] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

## <span id="structure">Directory structure</span> [**&#x25B4;**](#top)

This project is organized as follows:

<pre style="font-size:80%;">
bin\*.bat
bin\cfr-0.152.zip
bin\3.0\{<a href="bin/3.0/common.bat">common.bat</a>, <a href="bin/3.0/scala.bat">scala.bat</a>, <a href="bin/3.0/scalac.bat">scalac.bat</a>, <a href="bin/3.0/scaladoc.bat">scaladoc.bat</a>}
bin\3.1\{<a href="bin/3.1/common.bat">common.bat</a>, <a href="bin/3.1/scala.bat">scala.bat</a>, <a href="bin/3.1/scalac.bat">scalac.bat</a>, <a href="bin/3.1/scaladoc.bat">scaladoc.bat</a>}
bin\3.2\{<a href="bin/3.2/common.bat">common.bat</a>, <a href="bin/3.2/scala.bat">scala.bat</a>, <a href="bin/3.2/scalac.bat">scalac.bat</a>, <a href="bin/3.2/scaladoc.bat">scaladoc.bat</a>}
bin\dotty\
docs\
<a href="https://github.com/lampepfl/dotty">dotty</a>\     <i>(Git submodule)</i>
examples\{<a href="examples/README.md">README.md</a>, <a href="examples/dotty-example-project/">dotty-example-project</a>, ..}
maven-plugins\{<a href="maven-plugins/README.md">README.md</a>, <a href="./maven-plugins/scala-maven-plgin">scala-maven-plugin</a>, etc.}
myexamples\{<a href="myexamples/README.md">README.md</a>, <a href="myexamples/00_AutoParamTupling/">00_AutoParamTupling</a>, ..}
plugin-examples\{<a href="plugin-examples/README.md">README.md</a>, <a href="plugin-examples/DivideZero/">DivideZero</a>, ..}
rockthejvm-examples\{<a href="rockthejvm-examples/README.md">README.md</a>, <a href="rockthejvm-examples/Enums/">Enums</a>, ..}
semanticdb-examples\{<a href="semanticdb-examples/README.md">README.md</a>, <a href="semanticdb-examples/hello/">hello</a>, ..}
<a href="CONTRIBUTIONS.md">CONTRIBUTIONS.md</a>
<a href="DEPS.md">DEPS.md</a>
README.md
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="setenv.bat">setenv.bat</a>
<a href="UBUNTU_WSL.md">UBUNTU_WSL.md</a>
</pre>

where

- directory [**`bin\`**](bin/) provides several utility [batch files][windows_batch_file].
- file [**`bin\cfr-0.152.zip`**](bin/cfr-0.152.zip) contains a zipped distribution of [CFR][cfr_releases].
- directory [**`bin\3.0\`**](bin/3.0/) contains the batch commands for [Scala 3][scala3_relnotes].
- directory [**`bin\dotty\`**](bin/dotty/) contains several [batch files][windows_batch_file]/[bash scripts][unix_bash_script] for building the [Scala 3][scala3_home] software distribution on a Windows machine.
- directory [**`docs\`**](docs/) contains [Scala 3][scala3_home] related papers/articles (see file [**`docs\README.md`**](docs/README.md)).
- directory **`dotty\`** contains our fork of the [lampepfl/dotty][github_lampepfl_dotty] repository as a [Github submodule](.gitmodules).
- directory [**`examples\`**](examples/) contains [Scala 3][scala3_home] examples grabbed from various websites (see file [**`examples\README.md`**](examples/README.md)).
- directory [**`maven-plugins\`**](maven-plugins) presents our Maven plugin [`scala-maven-plugin`](./maven-plugins/README.md#scala_maven_plugin).
- directory [**`myexamples\`**](myexamples/) contains self-written [Scala 3][scala3_home] examples (see file [**`myexamples\README.md`**](myexamples/README.md)).
- directory [**`plugin-examples\`**](plugin-examples/) contains [Scala 3][scala3_home] plugin examples (see file [**`plugin-examples\README.md`**](plugin-examples/README.md)).
- directory [**`rockthejvm-examples\`**](rockthejvm-examples/) contains [Scala 3][scala3_home] code examples (see file [**`rockthejvm-examples\README.md`**](rockthejvm-examples/README.md)).
- directory [**`semanticdb-examples\`**](semanticdb-examples/) contains [SemanticDB][semanticdb_guide] code examples (see file [**`semanticdb-examples\README.md`**](semanticdb-examples/README.md)).
- file [**`CONTRIBUTIONS.md`**](CONTRIBUTIONS.md) lists PRs and issues we reported so far.
- file [**`DEPS.md`**](DEPS.md) lists library dependencies of available Scala distributions.
- file [**`README.md`**](README.md) is the [Markdown][github_markdown] document for this page.
- file [**`RESOURCES.md`**](RESOURCES.md) is the [Markdown][github_markdown] document presenting external resources.
- file [**`setenv.bat`**](setenv.bat) is the batch command for setting up our environment.
- file [**`UBUNTU_WSL.md`**](UBUNTU_WSL.md) presents a [Scala 3][scala3_home] code examples in [Ubuntu WSL][wsl].

<!--
> **:mag_right:** We use [VS Code][microsoft_vscode] with the extension [Markdown Preview Github Styling](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-preview-github-styles) to edit our Markdown files (see article ["Mastering Markdown"](https://guides.github.com/features/mastering-markdown/) from [GitHub Guides][github_guides].
-->

We also define a virtual drive **`W:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).
> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> Y: <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\workspace\dotty-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in this project.

## <span id="commands">Batch/Bash commands</span>

We distinguish different sets of batch/bash commands:

1. [**`setenv.bat`**](setenv.bat) &ndash; This batch command makes external tools such as [**`maven.cmd`**][apache_maven_cli], [**`mill.bat`**][mill_cli] and [**`sbt.bat`**][sbt_cli] directly available from the command prompt (see section [**Project dependencies**](#proj_deps)).

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

2. Directory [**`bin\`**](bin/) &ndash; This directory contains several utility batch files:
   - [**`cleanup.bat`**](bin/cleanup.bat) removes the generated class files from every example directory (both in [**`examples\`**](examples/) and [**`myexamples\`**](myexamples/) directories).
   - [**`dirsize.bat <dir_path_1> ..`**](bin/dirsize.bat) prints the size in Kb/Mb/Gb of the specified directory paths.
   - [**`getnightly.bat`**](bin/getnightly.bat) downloads/installs the distribution from the latest [Dotty nightly build](https://search.maven.org/search?q=g:ch.epfl.lamp).
   - [**`searchjars.bat <class_name>`**](bin/searchjars.bat) searches for the given class name into all Scala JAR files.
   - [**`timeit.bat <cmd_1> { & <cmd_2> }`**](bin/timeit.bat) prints the execution time of the specified commands.
   - [**`touch.bat <file_path>`**](bin/touch.bat) updates the modification date of an existing file or creates a new one.<div style="font-size:8px;">&nbsp;</div>

3. Directory [**`bin\3.0\`**](bin/3.0/) - This directory contains batch files to be copied to the **`bin\`** directory of the [Scala 3][scala3_home] installation for versions *prior to 3.0.2* in order to use the [**`scalac.bat`**](bin/3.0/scalac.bat), [**`scaladoc.bat`**](bin/3.0/scaladoc.bat) and [**`scala.bat`**](bin/3.0/scala.bat) commands on **Microsoft Windows**.
    > **&#9755;** Starting with version 3.0.2 those batch files are included in the [Scala 3][scala3_releases] software distribution (see [PR#13006](https://github.com/lampepfl/dotty/pull/13006), itself based on [PR#5444][github_PR5444]).

    <pre style="font-size:80%;">
    <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b c:\opt\scala3-3.2.1\bin</b>
    <a href="https://github.com/lampepfl/dotty/blob/master/dist/bin/common">common</a>
    <a href="bin/3.0/common.bat">common.bat</a>
    <a href="https://github.com/lampepfl/dotty/blob/master/dist/bin/scala">scala</a>
    <a href="bin/3.0/scala.bat">scala.bat</a>
    <a href="https://github.com/lampepfl/dotty/blob/master/dist/bin/scalac">scalac</a>
    <a href="bin/3.0/scalac.bat">scalac.bat</a>
    <a href="https://github.com/lampepfl/dotty/blob/master/dist/bin/scalad">scaladoc</a>
    <a href="bin/3.0/scaladoc.bat">scaladoc.bat</a>
    </pre>

<!-- ## removed on 2018-10-05 ##
    > **NB.** Prior to version 0.9-RC1 the [**`dotr`**](bin/0.9/dotr.bat) command did hang on Windows due to implementation issues with the Dotty [REPL](https://en.wikipedia.org/wiki/Read–eval–print_loop). This [issue](https://github.com/lampepfl/dotty/pull/4680) has been fixed by using [JLine 3](https://github.com/jline/jline3) in the REPL.
-->

4. File [**`bin\dotty\build.bat`**](bin/dotty/build.bat) - This batch command generates the [Scala 3][scala3_home] software distribution from the Windows command prompt.

5. File [**`bin\dotty\build.sh`**](bin/dotty/build.sh) - This bash command generates the [Scala 3][scala3_home] software distribution from the [Git Bash][git_bash] command prompt.

6. File [**`examples\*\build.bat`**](examples/dotty-example-project/build.bat) - Finally each example can be built/run using the [**`build.bat`**](examples/dotty-example-project/build.bat) command.<br/>
    > **&#9755;** We favor [**`build.bat`**](examples/dotty-example-project/build.bat) for the following reasons:
    > - It matches user commands executed from the Windows command prompt.
    > - It provides subcommands for working with <a href="https://www.benf.org/other/cfr/">CFR</a>, <a href="https://scalameta.org/scalafmt/">Scalafmt</a>, <a href="https://junit.org/junit4/">JUnit</a> and more.
    > - Code examples are simple (mostly one single source file).
    > - We don't need the [**`sbt`** ][sbt_cli] machinery (eg. [library dependencies][sbt_libs], [sbt server][sbt_server]).

    <pre style="font-size:80%;">
    <b>&gt; <a href="examples/dotty-example-project/build.bat">build</a></b>
    Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
    &nbsp;
      Options:
        -debug           show commands executed by this script
        -explain         set compiler option -explain
        -explain-types   set compiler option -explain-types
        -main:&lt;name&gt;     define main class name (default: Main)
        -print           print IR after compilation phase 'lambdaLift'
        -scala2          use Scala 2 tools
        -scala3          use Scala 3 tools (default)
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

## <span id="tools">Optional tools</span> [**&#x25B4;**](#top)

1. Build tools

    Code examples in directories [**`examples\`**](examples/) and [**`myexamples\`**](myexamples/) can also be built with the following tools as an alternative to the **`build.bat`** command (see [**`examples\README.md`**](examples/README.md) and [**`myexamples\README.md`**](myexamples/README.md) for more details):

    | **Build tool** | **Configuration file** | **Parent file** | **Usage example** |
    | :------------- | :--------------------- | :-------------- | :---------------- |
    | [**`ant.bat`**][apache_ant_cli] | [**`build.xml`**](examples/enum-Planet/build.xml) | [**`build.xml`**](examples/build.xml) | **`ant clean compile run`** |
    | [**`bazel.exe`**][bazel_cli] | [**`BUILD`**](examples/enum-Planet/BUILD) | n.a. | **`bazel run :enum-Planet`** |
    | [**`gradle.bat`**][gradle_cli] | [**`build.gradle`**](examples/enum-Planet/build.gradle) | [**`common.gradle`**](examples/common.gradle) | **`gradle clean build run`** |
    | [**`make.exe`**][gmake_cli] | [**`Makefile`**](examples/enum-Planet/Makefile) | [**`Makefile.inc`**](examples/Makefile.inc) | **`make clean run`** |
    | [**`mill.bat`**][mill_cli] | [**`build.sc`**](examples/enum-Planet/build.sc) | [**`common.sc`**](examples/common.sc) | **`mill -i app`** |
    | [**`mvn.cmd`**][apache_maven_cli] | [**`pom.xml`**](examples/enum-Planet/pom.xml) | [**`pom.xml`**](examples/pom.xml) | **`mvn clean compile test`** |
    | [**`sbt.bat`**][sbt_cli] | [**`build.sbt`**](examples/enum-Planet/build.sbt) | n.a. | **`sbt clean compile run`** |

2. Decompiler tools

    As an alternative to the standard [**`javap.exe`**][javap_cli] class decompiler one may use **`cfr.bat`** (simply extract [**`bin\cfr-0.152.zip`**](bin/cfr-0.152.zip) to **`c:\opt\`**) which prints [Java source code][java_jls] instead of [Java bytecode][java_bytecode]:

    <pre style="font-size:80%;">
    <b>&gt; <a href="https://www.benf.org/other/cfr/">cfr</a> myexamples\00_AutoParamTupling\target\classes\myexamples\Main.class</b>
    /*
     * Decompiled with CFR 0.152.
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

    Here is the console output from command [**`javap.exe`**][javap_cli] with option **`-c`** for the same class file:

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

Command [**`setenv.bat`**](setenv.bat) is executed once to setup our development environment; it makes external tools such as [**`bazel.exe`**][bazel_cli], [**`mvn.cmd`**][apache_maven_cli], [**`sbt.bat`**][sbt_cli] and [**`git.exe`**][git_cli] directly available from the command prompt.

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a></b>
Tool versions:
   javac 11.0.17, java 11.0.17, scalac 2.13.10, scalac 3.2.1,
   ant 1.10.12, gradle 7.5.1, mill 0.10.9, mvn 3.8.6, sbt 1.7.3,
   bazel 5.3.2, bloop v1.3.4, cfr 0.152, make 3.81, python 3.10.7,
   git 2.38.1.windows.1, diff 3.8, bash 4.4.23(1)-release

<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> sbt</b>
C:\opt\sbt-1.7.3\bin\sbt
C:\opt\sbt-1.7.3\bin\sbt.bat
</pre>

Other development tools such as [**`javac.exe`**][javac_cli] and [**`scalac.bat`**][scalac_cli] are accessible through the corresponding environment variable, e.g. **`JAVA_HOME`** for **`javac.exe`**, **`SCALA_HOME`** resp. **`SCALA3_HOME`** for **`scalac.bat`** and **`PYTHON_HOME`** for **`python.exe`**.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> javac</b>
INFO: Could not find files for the given pattern(s).
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> /r %JAVA_HOME% javac</b>
C:\opt\jdk-temurin-11.0.16.1_1\bin\javac.exe
&nbsp;
<b>&gt; %JAVA_HOME%\bin\<a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.html">javac</a> -version</b>
javac 11.0.16.1
</pre>

Command [**`setenv.bat -verbose`**](setenv.bat) also displays the tool paths and defined variables:

<pre style="font-size:80%;">
<b>&gt; <a href="setenv.bat">setenv</a> -verbose</b>
Tool versions:
   javac 11.0.17, java 11.0.17, scalac 2.13.10, scalac 3.2.1,
   ant 1.10.12, gradle 7.5.1, mill 0.10.9, mvn 3.8.6, sbt 1.7.3,
   bazel 5.3.2, cfr 0.152, make 3.81, python 3.11.0,
   git 2.38.1.windows.1, diff 3.8, bash 4.4.23(1)-release
Tool paths:
   C:\opt\jdk-temurin-11.0.17_8\bin\javac.exe
   C:\opt\jdk-temurin-11.0.17_8\bin\java.exe
   C:\opt\scala-2.13.10\bin\scalac.bat
   C:\opt\scala3-3.2.1\bin\scalac.bat
   %LOCALAPPDATA%\Coursier\data\bin\scalafmt.bat
   C:\opt\apache-ant-1.10.12\bin\ant.bat
   C:\opt\gradle-7.5.1\bin\gradle.bat
   C:\opt\mill-0.10.9\mill.bat
   C:\opt\apache-maven-3.8.6\bin\mvn.cmd
   C:\opt\sbt-1.7.3\bin\sbt.bat
   C:\opt\bazel-5.3.2\bazel.exe
   C:\opt\cfr-0.152\bin\cfr.bat
   C:\opt\make-3.81\bin\make.exe
   C:\opt\Python-3.11.0\python.exe
   C:\opt\Git-2.38.1\bin\git.exe
   C:\opt\Git-2.38.1\mingw64\bin\git.exe
   C:\opt\Git-2.38.1\usr\bin\diff.exe
   C:\opt\Git-2.38.1\bin\bash.exe
Environment variables:
   "ANT_HOME=C:\opt\apache-ant-1.10.12"
   "BAZEL_HOME=c:\opt\bazel-5.3.2"
   "GIT_HOME=C:\opt\Git-2.38.1"
   "JAVA_HOME=C:\opt\jdk-temurin-11.0.17_8"
   "JAVAFX_HOME=C:\opt\javafx-sdk-17.0.2"
   "MSVS_HOME=X:"
   "MSYS_HOME=C:\opt\msys64"
   "PYTHON_HOME=C:\opt\Python-3.10.7"
   "SBT_HOME=C:\opt\sbt-1.7.3"
   "SCALA_HOME=C:\opt\scala-2.13.10"
   "SCALA3_HOME=C:\opt\scala3-3.2.1"
</pre>

### **`cleanup.bat`**

Command [**`cleanup.bat`**](bin/cleanup.bat) removes the output directories (ie. **`target\`**) from the example projects: 

<pre style="font-size:80%;">
<b>&gt; <a href="bin/cleanup.bat">cleanup</a></b>
Finished to clean up 2 subdirectories in Y:\dotty\cdsexamples
Finished to clean up 16 subdirectories in Y:\dotty\examples
Finished to clean up 12 subdirectories in Y:\dotty\myexamples
</pre>

### **`dirsize.bat {<dir_name>}`**

Command [**`dirsize.bat`**](bin/dirsize.bat) returns the size (in Kb, Mb or Gb) of the specified directory paths:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/dirsize.bat">dirsize</a> examples myexamples c:\opt\scala3-3.2.1 c:\opt\jdk-temurin-11.0.17_8</b>
Size of directory "examples" is 3.9 Mb
Size of directory "myexamples" is 1.2 Mb
Size of directory "c:\opt\scala3-3.2.1" is 35.7 Mb
Size of directory "c:\opt\jdk-temurin-11.0.17_8" is 301.0 Mb
</pre>

### **`getnightly.bat`**

By default command [**`getnightly.bat`**](bin/getnightly.bat) downloads the library files of the latest [Dotty nightly build][dotty_nightly] available from the [Maven Central Repository][maven_lamp] and saves them into directory **`out\nightly\`**.

<pre style="font-size:80%;">
<b>&gt; <a href="bin/getnightly.bat">getnightly</a></b>
Usage: getnightly { &lt;option&gt; | &lt;subcommand&gt; }
&nbsp;
  Options:
    -debug      show commands executed by this script
    -timer      display total elapsed time
    -verbose    display download progress
&nbsp;
  Subcommands:
    activate    activate the nightly build library files
    download    download nighty build files and quit (default)
    help        display this help message
    restore     restore the default Scala library files
</pre>

Command [**`getnightly.bat download`**](bin/getnightly.bat) with options **` -verbose`** also displays the download progress:

<pre style="font-size:80%">
<b>&gt; <a href="bin/getnightly.bat">getnightly</a> -verbose download</b>
Delete directory "out\nightly"
Download Scala 3 nightly files from Maven repository
Downloading file scaladoc_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar ... 3.7 Mb
Downloading file scala3-interfaces-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar ... 3.5 Kb
Downloading file scala3-library_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar ... 1.2 Mb
Downloading file scala3-compiler_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar ... 16.8 Mb
Downloading file scala3-language-server_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar ... 149.2 Kb
Downloading file scala3-staging_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar ... 37.8 Kb
Downloading file tasty-core_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar ... 72.4 Kb
Downloading file scala3-library_sjs1_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar ... 1.9 Mb
Downloading file scala3-tasty-inspector_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar ... 17.4 Kb
Downloading file scala3-sbt-bridge-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar ... 21.8 Kb
Downloading file antlr-runtime-4.7.2.jar ... 0.5 Kb
[...]
Downloading file common ... 6 Kb
Downloading file common.bat ... 3 Kb
Downloading file scala ... 1.8 Kb
Downloading file scala.bat ... 3.7 Kb
Downloading file scalac ... 2.6 Kb
Downloading file scalac.bat ... 5.2 Kb
Downloading file scaladoc ... 4.4 Kb
Downloading file scaladoc.bat ... 4.8 Kb
Finished to download 53 files to directory "out\nightly"
Retrieve revision for hash "93fc41f" from GitHub repository "lampepfl/dotty"
File "out\nightly\VERSION":
version:=3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY
revision:=93fc41fcb624df73cc12d52b79d518a30a778a7c
buildTime:=2022-04-15 21:48:29+02:00
</pre>

Directory **`out\nightly\`** contains the two directories **`bin\`** and **`lib\`**:

<pre style="font-size:80%">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b out\nightly\bin out\nightly\lib</b>
common
common.bat
scala
scala.bat
scalac
scalac.bat
scaladoc
scaladoc.bat
antlr-runtime-3.5.1.jar
autolink-0.6.0.jar
[...]
scala-asm-9.3.0-scala-1.jar
scala-library-2.13.9.jar
scala3-compiler_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar
scala3-interfaces-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar
scala3-language-server_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar
scala3-library_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar
scala3-library_sjs1_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar
scala3-sbt-bridge-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar
scala3-staging_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar
scala3-tasty-inspector_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar
scaladoc_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar
snakeyaml-1.27.jar
strftime4j-1.0.5.jar
tasty-core_3-3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY.jar
</pre>
<!--
> **:mag_right:** A few notes about the distributed Java archives:
> - Dotty versions up to `0.18.0` depend on **`scala-library-2.12.8.jar`**; Dotty versions `0.18.1` and newer depend on **`scala-library-2.13.x.jar`**.
> - Starting with Dotty version `0.22.0` package **`dotty.tools.tasty`** is distributed separately in archive **`tast-core_<xxx>.jar`**.
> - Starting with Dotty version `0.28.0` package **`dotty-library_sjs1.x.jar`** is part of the software distribution.<br/>&nbsp;
-->

Concretely, subcommand **`activate`** switches to the nightly build version and subcommand **`restore`** restore the path to the [Scala 3][scala3_home] installation directory.

<pre style="font-size:80%;">
<b>&gt; <a href="bin/getnightly.bat">getnightly</a> activate</b>
Active Scala 3 installation is 3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY (was 3.2.1)

<b>&gt; %SCALA3_HOME%\bin\<a href="bin/3.0/scalac.bat">scalac</a> -version</b>
Scala compiler version 3.2.2-RC1-bin-20221018-93fc41f-NIGHTLY-git-93fc41f -- Copyright 2002-2022, LAMP/EPFL

<b>&gt; <a href="bin/getnightly.bat">getnightly</a> restore</b>
Active Scala 3 installation is 3.2.1

<b>&gt; %SCALA3_HOME%\bin\<a href="bin/3.0/scalac.bat">scalac</a> -version</b>
Scala compiler version 3.2.1 -- Copyright 2002-2022, LAMP/EPFL
</pre>

> **:warning:** You need *write access* to the [Scala 3][scala3_home] installation directory (e.g. **`C:\opt\scala3-3.2.1\`** in our case) in order to successfully run the **`activate/reset`** subcommands.

### `searchjars.bat <class_name>`

Command [**`searchjars.bat`**](bin/searchjars.bat) helps us to search for class file names in the following directories: project's **`lib\`** directory (*if present*), Dotty's **`lib\`** directory, Java's **`lib\`** directory and Ivy/Maven default directories.

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> -help</b>
Usage: searchjars { &lt;option&gt; | &lt;class_name&gt; }
&nbsp;
  Options:
    -artifact        search in ~\.ivy2 and ~\.m2 directories
    -help            display this help message
    -ivy             search in ~\.ivy directory
    -java            search in Java library directories
    -maven           search in ~\.m2 directory
    -scala           search in Scala library directories
    -verbose         display download progress
&nbsp;
  Arguments:
    &lt;class_name&gt;     class name
</pre>

Passing argument **`System`** to command [**`searchjars.bat`**](bin/searchjars.bat) prints the following output (class file names are printed with full path and are prefixed with their containing [JAR file][jar_file]:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> System</b>
Searching for class name System in archive files C:\opt\scala3-3.2.1\lib\*.jar
  jline-reader-3.19.0.jar:org/jline/reader/impl/completer/SystemCompleter.class
  scala-library-2.13.9.jar:scala/sys/SystemProperties$.class
  scala-library-2.13.9.jar:scala/sys/SystemProperties.class
Searching for class name System in archive files C:\opt\scala-2.13.10\lib\*.jar
  jline-3.19.0.jar:org/jline/builtins/SystemRegistryImpl$CommandOutputStream.class
  [...]
  scala-library.jar:scala/sys/SystemProperties$.class
  scala-library.jar:scala/sys/SystemProperties.class
Searching for class name System in archive files C:\opt\jdk-temurin-11.0.17_8\lib\*.jar
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystem$1.class
  [...]
  jrt-fs.jar:jdk/internal/jrtfs/SystemImage$2.class
  jrt-fs.jar:jdk/internal/jrtfs/SystemImage.class
Searching for class name System in archive files c:\opt\javafx-sdk-17.0.2\lib\*.jar
  javafx.graphics.jar:com/sun/glass/ui/SystemClipboard.class
  [...]
  javafx.graphics.jar:com/sun/javafx/tk/TKSystemMenu.class
  javafx.web.jar:com/sun/webkit/FileSystem.class
</pre>

Searching for an unknown class name - e.g. **`BinarySearch`** - produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> BinarySearch</b>
Searching for class name BinarySearch in archive files C:\opt\scala3-4\lib\*.jar
Searching for class name BinarySearch in archive files C:\opt\scala-2.13.10\lib\*.jar
Searching for class name BinarySearch in archive files C:\opt\jdk-temurin-11.0.17_8\lib\*.jar
</pre>

Searching for **`FileSystem`** with option **`-artifact`** produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="bin/searchjars.bat">searchjars</a> FileSystem -artifact</b>
Searching for class name FileSystem in archive files C:\opt\scala3-3.2.1\lib\*.jar
Searching for class name FileSystem in archive files C:\opt\scala-2.13.10\lib\*.jar
Searching for class name FileSystem in archive files c:\opt\jdk-temurin-11.0.17_8\lib\*.jar
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystem$1.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystem.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystemProvider$1.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystemProvider$JrtFsLoader.class
  jrt-fs.jar:jdk/internal/jrtfs/JrtFileSystemProvider.class
Searching for class name FileSystem in archive files c:\opt\javafx-sdk-17\lib\*.jar
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

Command [**`timeit.bat`**](bin/timeit.bat) prints the execution time (`hh:MM:ss` format) of the specified command (possibly given with options and parameters):

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
| `build.sbt` | `dottyVersion` | `3.2.1-RC1` &rarr; `3.2.1`|
| `build.sc` | `scalaVersion` | `3.2.1-RC1` &rarr; `3.2.1` |
| `project\build.properties` | `sbt.version` | `1.6.2` &rarr; `1.7.3` |
| `project\plugins.sbt` | `sbt-dotty` | `0.5.4` &rarr; `0.5.5` |

> **:construction:** Currently we have to edit the value pairs (old/new) directly in the batch file.

<pre style="margin:10px 0 0 30px;font-size:80%;">
<b>&gt; <a href="bin/updateprojs.bat">updateprojs</a></b>
Parent directory: Y:\dotty\examples
   Warning: Could not find file hello-scala\project\plugins.sbt
   Warning: Could not find file UnionTypes_0.4\project\plugins.sbt
   Updated 17 build.sbt files
   Updated 17 project\build.properties files
   Updated 15 project\plugins.sbt files
Parent directory: Y:\dotty\myexamples
   Warning: Could not find file 07_Value_Types\build.sbt
   Warning: Could not find file 07_Value_Types\project\build.properties
   Warning: Could not find file 07_Value_Types\project\plugins.sbt
   Updated 11 build.sbt files
   Updated 11 project\build.properties files
   Updated 11 project\plugins.sbt files
</pre>
-->

### `build.bat`

Command [**`build.bat`**](examples/enum-Planet/build.bat) is a basic build tool consisting of ~800 lines of batch/[Powershell ][microsoft_powershell] code <sup id="anchor_05">[[5]](#footnote_05)</sup>.

Running command [**`build`.bat**](examples/enum-Planet/build.bat) with ***no*** option in project [**`examples\enum-Planet`**](examples/enum-Planet/) generates the following output:

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

[Scala REPL][scala_repl] is an interactive tool for evaluating [Scala] expressions. Internally, it executes a source script by wrapping it in a template and then compiling and executing the resulting program.

   > **:warning:** Batch file [**`scala.bat`**](bin/3.0/scala.bat) is based on the bash script [**`scala`**][github_scala] available from the standard [Scala 3 distribution][scala3_releases]. We also have submitted pull request [#5444][github_PR5444] to add that batch file to the Dotty distribution.

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/where_1" rel="external">where</a> scala</b>
C:\opt\scala3-3.2.1\bin\scala
C:\opt\scala3-3.2.1\bin\scala.bat

<b>&gt; <a href="bin/3.0/scala.bat">scala</a> -version</b>
Scala code runner version 3.2.1 -- Copyright 2002-2022, LAMP/EPFL

<b>&gt; <a href="bin/3.0/scala.bat">scala</a></b>
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
val res0: String = C:\opt\jdk-temurin-11.0.17_8

<b>scala&gt;</b> System.getenv().get("SCALA3_HOME")
val res1: String = C:\opt\scala3-3.2.1

<b>scala&gt;</b> :load myexamples/HelloWorld/src/main/scala/HelloWorld.scala
// defined object HelloWorld

<b>scala&gt;</b> HelloWorld.main(Array())
Hello world!

<b>scala&gt;</b>:quit
</pre>

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)

<span id="footnote_01">[1]</span> ***Java LTS versions*** [↩](#anchor_01) <!-- 2018-11-18 -->

<dl><dd>
Oracle annonces in his <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">Java SE Support Roadmap</a> he will stop public updates of Java SE 8 for commercial use after January 2019. Current LTS versions are (from <a href="https://www.oracle.com/java/technologies/java-se-support-roadmap.html">Oracle's support roadmap</a>):
</dd>
<dd>
<table>
<tr><th>Java LTS Version</th><th>GA</th><th>End of life</th></tr>
<tr>
  <td>21</td>
  <td>September 2023</td>
  <td>September 2031</td>
</tr>
<tr>
  <td><a href="https://www.oracle.com/java/technologies/downloads/#java17">17</a></td>
  <td>September 2021</td>
  <td>September 2029</td>
</tr>
<tr>
  <td><a href="https://www.oracle.com/java/technologies/downloads/#java11">11</a></td>
  <td>September 2018</td>
  <td>September 2026</td>
</tr>
<tr>
  <td><a href="https://www.oracle.com/java/technologies/downloads/#java8">8</a></td>
  <td> March 2014</td>
  <td>December 2030 <sup>(1)</sup></td>
</tr>
</table>
<div style="font-size:80%;"><sup>(1)</sup> The Extended Support uplift fee will be waived for the period March 2022 - December 2030 for Java SE 8.
</dd>
<dd>
<b>NB.</b> See also <a href="https://www.azul.com/products/azul-support-roadmap/">Zulu's support roadmap</a>.
</dd></dl>

<span id="footnote_02">[2]</b> ***Using Bazel on Windows*** [↩](#anchor_02)

<dl><dd>
Read the page <a href="https://docs.bazel.build/versions/master/windows.html#build-on-windows" rel="external">Builds on Windows</a> of the <a href="https://www.bazel.build/" rel="external">Bazel website</a> for tips to build with MSVC, Clang, Java or Python on a Windows machine.
</dd>
<dd>
For instance, for Visual Studio 2019, we set variable <b><code>BAZEL_VC</code></b> to the Visual C++ Build Tools installation directory:
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/set_1">set</a></b> "BAZEL_VC=C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC"
</pre>
</dd></dl>

<span id="footnote_03">[3]</span> ***JaCoCo and Java support*** [↩](#anchor_03)

<dl><dd>
<table style="font-size:90%;">
<tr>
  <th><a href="https://www.eclemma.org/jacoco/" rel="external">JaCoCo</a> version</th>
  <th>Supported Java version</th>
  <th>Depends on <a href="https://asm.ow2.io/" rel="external">ASM</a></th>
</tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.9</a>&nbsp;<i style="font-size:80%;">(October&nbsp;2022)</i></td><td>19 and 20</td><td><a href="https://asm.ow2.io/versions.html">9.4</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.8</a> <i style="font-size:80%;">(April 2022)</i></td><td>17 and 18</td><td><a href="https://asm.ow2.io/versions.html">9.2</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.7</a> <i style="font-size:80%;">(May 2021)</i></td><td>15 and 16</td><td><a href="https://asm.ow2.io/versions.html">9.1</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.6</a> <i style="font-size:80%;">(Sept 2020)</i></td><td>14</td><td><a href="https://asm.ow2.io/versions.html">8.0.1</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.5</a> <i style="font-size:80%;">(Oct 2019)</i></td><td>13</td><td><a href="https://asm.ow2.io/versions.html">7.2</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.4</a> <i style="font-size:80%;">(May 2019)</i></td><td>12</td><td><a href="https://asm.ow2.io/versions.html">7.1</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.3</a> <i style="font-size:80%;">(Jan 2019)</i></td><td>11</td><td><a href="https://asm.ow2.io/versions.html">7.0</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.2</a> <i style="font-size:80%;">(Aug 2018)</i></td><td>&nbsp;</td><td><a href="https://asm.ow2.io/versions.html">6.2.1</a></td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.1</a> <i style="font-size:80%;">(March 2018)</i></td><td>10</td><td>&nbsp;</td></tr>
<tr><td><a href="https://www.jacoco.org/jacoco/trunk/doc/changes.html">0.8.0</a> <i style="font-size:80%;">(Jan 2018)</i></td><td>9</td><td><a href="https://asm.ow2.io/versions.html">6.0</a></td></tr>
</table>
</dd></dl>

<span id="footnote_04">[4]</span> ***Downloads*** [↩](#anchor_04)

<dl><dd>
In our case we downloaded the following installation files (<a href="#proj_deps">see section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<a href="https://github.com/lihaoyi/mill/releases">0.10.9-assembly</a> (<code>mill</code>)                             <i>( 64 MB)</i>
<a href="https://ant.apache.org/bindownload.cgi">apache-ant-1.10.12-bin.zip</a>                         <i>(  9 MB)</i>
<a href="https://maven.apache.org/download.cgi">apache-maven-3.8.6-bin.zip</a>                         <i>( 10 MB)</i>
<a href="https://github.com/bazelbuild/bazel/releases">bazel-5.3.2-windows-x86_64.zip</a>                     <i>( 40 MB)</i>
<a href="https://gradle.org/install/">gradle-7.5.1-bin.zip</a>                               <i>(103 MB)</i>
<a href="https://www.eclemma.org/jacoco/">jacoco-0.8.8.zip</a>                                   <i>(  4 MB)</i>
<a href="https://github.com/AdoptOpenJDK/jitwatch/releases">jitwatch-ui-1.4.7-shaded-win.jar</a>                   <i>( 36 MB)</i>
<a href="https://sourceforge.net/projects/gnuwin32/files/make/3.81/">make-3.81-bin.zip</a>                                  <i>( 10 MB)</i>
<a href="http://repo.msys2.org/distrib/x86_64/">msys2-x86_64-20210228.exe</a>                          <i>( 94 MB)</i>
<a href="http://jdk.java.net/17/">openjdk-17_windows-x64_bin.zip</a>                     <i>(176 MB)</i>
<a href="https://gluonhq.com/products/javafx/">openjfx-17_windows-x64_bin-sdk.zip</a>                 <i>( 39 MB)</i>
<a href="https://adoptium.net/releases.html?variant=openjdk8&jvmVariant=hotspot">OpenJDK8U-jdk_x64_windows_hotspot_8u345b01.zip</a>     <i>( 99 MB)</i>
<a href="https://adoptium.net/releases.html?variant=openjdk11&jvmVariant=hotspot">OpenJDK11U-jdk_x64_windows_hotspot_11.0.17_8.zip</a>   <i>(188 MB)</i>
<a href="https://adoptium.net/releases.html?variant=openjdk11&jvmVariant=hotspot">OpenJDK11U-jdk_x64_windows_hotspot_17.0.5_8.zip</a>    <i>(188 MB)</i>
<a href="https://git-scm.com/download/win">PortableGit-2.38.1-64-bit.7z.exe</a>                   <i>( 41 MB)</i>
<a href="https://github.com/sbt/sbt/releases">sbt-1.7.3.zip</a>                                      <i>( 17 MB)</i>
<a href="https://www.scala-lang.org/files/archive/">scala-2.13.10.zip</a>                                  <i>( 22 MB)</i>
<a href="https://github.com/lampepfl/dotty/releases/tag/3.2.1">scala3-3.2.1.zip</a>                                   <i>( 34 MB)</i>
</pre>
</dd></dl>

<span id="footnote_05">[5]</span> ***PowerShell*** [↩](#anchor_05) <!-- 2018-05-09 -->

<dl><dd> 
Command Prompt has been around for as long as we can remember, but starting with Windows 10 build 14971, Microsoft is trying to make <a href="https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6">PowerShell</a> the <a href="https://support.microsoft.com/en-us/help/4027690/windows-powershell-is-replacing-command-prompt">main command shell</a> in the operating system.
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2022* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples
[akka_examples]: https://github.com/michelou/akka-examples
[apache_ant]: https://ant.apache.org/
[apache_ant_cli]: https://ant.apache.org/manual/running.html
[apache_ant_relnotes]: https://archive.apache.org/dist/ant/RELEASE-NOTES-1.10.12.html
[apache_ant_scripting]: https://ant.apache.org/manual/using.html "Writing a Simple Buildfile"
[apache_maven]: https://maven.apache.org/download.cgi
[apache_maven_cli]: https://maven.apache.org/ref/current/maven-embedder/cli.html
[apache_maven_history]: https://maven.apache.org/docs/history.html
[apache_maven_relnotes]: https://maven.apache.org/docs/3.8.6/release-notes.html
[bazel_cli]: https://docs.bazel.build/versions/master/command-line-reference.html
[bazel_releases]: https://github.com/bazelbuild/bazel/releases
<!--
[bazel_relnotes]: https://blog.bazel.build/2022/01/19/bazel-5.0.html
[bazel_relnotes]: https://blog.bazel.build/2022/03/24/bazel-5.1.html
[bazel_relnotes]: https://blog.bazel.build/2022/06/08/bazel-5.2.html
[bazel_relnotes]: https://blog.bazel.build/2022/08/23/bazel-5.3.html
-->
[bazel_relnotes]: https://blog.bazel.build/2022/08/23/bazel-5.3.html
[bloop_releases]: https://scalacenter.github.io/bloop/
[bloop_relnotes]: https://github.com/scalacenter/bloop/releases/tag/v1.3.4
[cfr_releases]: https://www.benf.org/other/cfr/
[cpp_examples]: https://github.com/michelou/cpp-examples
[deno_examples]: https://github.com/michelou/deno-examples
[dotty]: https://dotty.epfl.ch
[dotty_metaprogramming]: https://dotty.epfl.ch/docs/reference/metaprogramming/toc.html
[dotty_nightly]: https://search.maven.org/search?q=g:ch.epfl.lamp
[flix_examples]: https://github.com/michelou/flix-examples
[github_scala]: https://github.com/lampepfl/dotty/blob/master/dist/bin/scala
[git_bash]: https://www.atlassian.com/git/tutorials/git-bash
[git_cli]: https://git-scm.com/docs/git
[git_releases]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.38.1.txt
[github_guides]: https://guides.github.com/
[github_lampepfl_dotty]: https://github.com/lampepfl/dotty
[github_markdown]: https://github.github.com/gfm/
[github_PR5444]: https://github.com/lampepfl/dotty/pull/5444
[gmake_cli]: http://www.glue.umd.edu/lsf-docs/man/gmake.html
[golang_examples]: https://github.com/michelou/golang-examples
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_compatibility]: https://docs.gradle.org/current/release-notes.html#upgrade-instructions
[gradle_install]: https://gradle.org/install/
[gradle_relnotes]: https://docs.gradle.org/7.6/release-notes.html
[haskell_examples]: https://github.com/michelou/haskell-examples
[jacoco_changelog]: https://www.jacoco.org/jacoco/trunk/doc/changes.html
[jacoco_downloads]: https://www.eclemma.org/jacoco/
[jar_file]: https://docs.oracle.com/javase/8/docs/technotes/guides/jar/jarGuide.html
[java_bytecode]: https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-6.html
[java_jls]: https://docs.oracle.com/javase/specs/jls/se8/html/index.html
[javac_cli]: https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.html
[javafx_downloads]: https://gluonhq.com/products/javafx/
[javafx_relnotes]: https://gluonhq.com/products/javafx/openjfx-17-release-notes/
[javap_cli]: https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javap.html
[jitwatch_releases]: https://github.com/AdoptOpenJDK/jitwatch/releases
[jmh]: https://openjdk.java.net/projects/code-tools/jmh/
[kotlin_examples]: https://github.com/michelou/kotlin-examples
[llvm_examples]: https://github.com/michelou/llvm-examples
[make_downloads]: https://sourceforge.net/projects/gnuwin32/files/make/3.81/
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
[mill_cli]: https://com-lihaoyi.github.io/mill/#command-line-tools
[mill_releases]: https://github.com/lihaoyi/mill/releases/
[msys2_changelog]: https://github.com/msys2/setup-msys2/blob/master/CHANGELOG.md
[msys2_releases]: https://github.com/msys2/msys2-installer/releases
[nodejs_examples]: https://github.com/michelou/nodejs-examples
[rust_examples]: https://github.com/michelou/rust-examples
[sbt_cli]: https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html
[sbt_downloads]: https://github.com/sbt/sbt/releases
[sbt_libs]: https://www.scala-sbt.org/1.x/docs/Library-Dependencies.html
[sbt_relnotes]: https://github.com/sbt/sbt/releases/tag/v1.8
[sbt_server]: https://www.scala-sbt.org/1.x/docs/sbt-server.html
[scala]: https://www.scala-lang.org/
[scala3_home]: https://dotty.epfl.ch
[scala3_releases]: https://github.com/lampepfl/dotty/releases
[scala3_relnotes]: https://github.com/lampepfl/dotty/releases/tag/3.2.1
[scala_releases]: https://www.scala-lang.org/files/archive/
[scala_relnotes]: https://github.com/scala/scala/releases/tag/v2.13.10
[scala_repl]: https://docs.scala-lang.org/overviews/repl/overview.html
[scalac_cli]: https://docs.scala-lang.org/overviews/compiler-options/index.html
[semanticdb_guide]: https://scalameta.org/docs/semanticdb/guide.html
[spark_examples]: https://github.com/michelou/spark-examples
[spring_examples]: https://github.com/michelou/spring-examples
[temurin_openjdk8]: https://adoptium.net/releases.html?variant=openjdk8&jvmVariant=hotspot
[temurin_openjdk8_relnotes]: https://mail.openjdk.java.net/pipermail/jdk8u-dev/2022-January/014522.html
<!--
8u302   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2021-July/014118.html
8u312   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2021-October/014373.html
8u321   -> https://www.oracle.com/java/technologies/javase/8u321-relnotes.html
8u322   -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2022-January/014522.html
11.0.3  -> http://mail.openjdk.java.net/pipermail/jdk-updates-dev/2019-April/000951.html
11.0.11 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-April/005860.html
11.0.12 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-July/006954.html
11.0.13 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2021-October/009368.html
11.0.14 -> https://mail.openjdk.java.net/pipermail/jdk-updates-dev/2022-January/011643.html
-->
[temurin_opendjk11_bugfixes]: https://www.oracle.com/java/technologies/javase/11-0-14-bugfixes.html
[temurin_opendjk11_relnotes]: https://mail.openjdk.org/pipermail/jdk-updates-dev/2022-July/016017.html
[temurin_opendjk11]: https://adoptium.net/releases.html?variant=openjdk11&jvmVariant=hotspot
[temurin_opendjk17]: https://adoptium.net/releases.html?variant=openjdk17&jvmVariant=hotspot
[temurin_opendjk17_bugfixes]: https://www.oracle.com/java/technologies/javase/17-0-2-bugfixes.html
[temurin_opendjk17_relnotes]: https://github.com/openjdk/jdk/compare/jdk-17%2B20...jdk-17%2B21
<!--
[python_changelog]: https://docs.python.org/3.8/whatsnew/changelog.html#python-3-8-0-final
[python_release]: https://www.python.org/downloads/release/python-380/
-->
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[unix_bash_script]: https://www.gnu.org/software/bash/manual/bash.html
[unix_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[windows_batch_file]: https://en.wikibooks.org/wiki/Windows_Batch_Scripting
[windows_installer]: https://docs.microsoft.com/en-us/windows/win32/msi/windows-installer-portal
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[wix_examples]: https://github.com/michelou/wix-examples
[wsl]: https://ubuntu.com/wsl "Ubuntu WSL"
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/ "Everything You Need to Know About Zip Files"
