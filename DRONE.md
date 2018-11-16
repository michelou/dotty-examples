# Building Dotty on Windows

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    The source code of the <a href="http://dotty.epfl.ch/">Dotty project</a> is hosted on <a href="https://github.com/lampepfl/dotty/">Github</a> and continuous delivery is achieved by the <a href="https://drone.io/">Drone platform</a> hosted on an <a href="http://dotty-ci.epfl.ch/lampepfl/dotty">EPFL server</a>.</br>This page describes the additions/changes we made in our <a href="https://github.com/michelou/dotty">fork</a> of the <a href="https://github.com/lampepfl/dotty/">Dotty remote</a> in order to reproduce the same build/test steps on the <b>Microsoft Windows</b> platform.
  </td>
  </tr>
</table>

## Project dependencies

Our <a href="https://github.com/michelou/dotty">Dotty fork</a> depends on three external software for the **Microsoft Windows** platform:

- [Oracle Java 8 SDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) ([*release notes*](http://www.oracle.com/technetwork/java/javase/8u-relnotes-2225394.html))
- [SBT 1.2.6](https://www.scala-sbt.org/download.html) (with Scala 2.12.17 preloaded) ([*release notes*](https://github.com/sbt/sbt/releases/tag/v1.2.6))
- [Git 2.19](https://git-scm.com/download/win) ([*release notes*](https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.19.0.txt))

> ***Installation policy***<br/>
> Whenever possible software is installed via a Zip archive rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in memory of* the [`/opt/`](http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) directory on Unix).

For instance our development environment looks as follows (*November 2018*):

<pre style="font-size:80%;">
C:\Program Files\Java\jdk1.8.0_191\
C:\opt\sbt-1.2.6\
C:\opt\Git-2.19.1\
</pre>

## Directory structure

The directory structure of the [Dotty repository](https://github.com/lampepfl/dotty/) is quite complex but fortunately we only have to deal with the three (sub-)directories **`bin\`**, **`dist\bin\`** and **`project\scripts\`**.

<pre style="font-size:80%;">
> dir /ad /b
.git
.vscode-template
bench
bin
collection-strawman
compiler
dist
doc-tool
docs
interfaces
language-server
library
project
sandbox
sbt-bridge
sbt-dotty
scala-backend
scala2-library
semanticdb
tests
vscode-dotty
</pre>

> **NB.** The three directories **`collection-strawman\`**, **`scala-backend\`** and **`scala2-library\`** are actually Git submodules; we invite you to read ["Mastering Git Submodules"](https://delicious-insights.com/en/posts/mastering-git-submodules/) from [Delicious Insights](https://delicious-insights.com/en/) (Jan 8, 2015).

Concretely directories **`bin\`**, **`dist\bin\`**, **`project\scripts\`** and the root directory contain the following additions:

<pre style="font-size:80%;">
bin\common.bat
bin\dotc.bat
bin\dotd.bat
bin\dotr.bat
dist\bin\common.bat
dist\bin\dotc.bat
dist\bin\dotd.bat
dist\bin\dotr.bat
project\scripts\build.bat
setenv.bat
</pre>

In the next section we give a brief description of the batch scripts present in those directories.

## Batch scripts

We distinguish different sets of batch scripts:

1. [**`setenv.bat`**](https://github.com/michelou/dotty/blob/master/setenv.bat) - This batch script makes external tools such as **`java.exe`**, **`sbt.bat`** and **`git.exe`** directly available from the command prompt.

    <pre style="font-size:80%;">
    &gt; java -version
    java version "1.8.0_191"
    Java(TM) SE Runtime Environment (build 1.8.0_191-b12)
    Java HotSpot(TM) 64-Bit Server VM (build 25.191-b12, mixed mode)

    &gt; git --version
    git version 2.19.1.windows.1
    </pre>

2. Directory [**`bin\`** ](https://github.com/michelou/dotty/tree/batch-files/bin) - This directory contains the batch files used internally during the build process.

3. Directory [**`dist\bin\`** ](https://github.com/michelou/dotty/tree/batch-files/dist/bin) - This directory contains the shell scripts and batch files to be added unchanged to a [Dotty software release](https://github.com/lampepfl/dotty/releases).

    <pre style="font-size:80%;">
    &gt; dir /b .\dist\bin
    common
    common.bat
    dot.bat
    dotc
    dotc.bat
    dotd
    dotd.bat
    dotr
    dotr.bat
    </pre>

4. [**`build.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/build.bat) - This batch script performs similar build/test steps as on the [EPFL server](http://dotty-ci.epfl.ch/lampepfl/dotty) on a local Windows machine.

    <pre style="font-size:80%;">
    &gt; build help
    Usage: build { options | subcommands }
      Options:
        -timer                 display the total build time
        -verbose               display environment settings
      Subcommands:
        arch[ives]             generate gz/zip archives (after bootstrap)
        arch[ives]-only        generate ONLY gz/zip archives
        boot[strap]            generate bootstrap compiler (after compile)
        boot[strap]-only       generate ONLY bootstrap compiler
        cleanall               clean project (sbt+git) and quit
        clone                  update submodules
        compile                genarate 1st stage compiler (after clone)
        doc[umentation]        generate documentation (after bootstrap)
        doc[umentation]-only]  generate ONLY documentation
        help                   display this help message
</pre>

The execution of the above subcommands obeys the following dependency rules:

| **A** depends on **B** | Output from **A** |
| ------------- | ------------- |
| **`cleanall`** &rarr; *none* | &nbsp; |
| **`clone`** &rarr; *none* | &nbsp; |
| **`compile`** &rarr; **`clone`** | &nbsp; |
| **`bootstrap`** &rarr; **`compile`** | &nbsp; |
| **`archives`** &rarr; **`bootstrap`** | **`dist\bootstrapped\*.gz,*.zip`** |
| **`documentation`** &rarr; **`bootstrap`** | &nbsp; |

## Windows related issues

We have come across several Windows related issues while executing subcommands of [**`build.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/build.bat); in particular:

| Subcommand | Bug report |
| ---------- | ---------- |
| **`compile`** | [#5457](https://github.com/lampepfl/dotty/pull/5457) |
| **`bootstrap`** | *pending* |
| **`documentation`** | [#5430](https://github.com/lampepfl/dotty/pull/5430) |
| *code review* | [#5452](https://github.com/lampepfl/dotty/pull/5452) |

In summary, we encountered several Windows related issues with the <a href="https://github.com/lampepfl/dotty/">source code</a> of the <a href="http://dotty.epfl.ch/">Dotty project</a>:

- Unspecified text encoding in some file operations<br/>*Example*: [**`Source`**](https://www.scala-lang.org/api/2.12.7/scala/io/Source$.html)**`.fromFile(f)`** **&rarr;**[**`Source`**](https://www.scala-lang.org/api/2.12.7/scala/io/Source$.html)**`.fromFile(f, "UTF-8")`**.
- Platform-specific new lines<br/>*Example*: **`"\n"`** **&rarr;** **`sys.props("line.separator")`**.
- Platform-specific path separators<br/>*Example*: **`":"`** **&rarr;** [**`java.io.File.pathSeparator`**](https://docs.oracle.com/javase/8/docs/api/java/io/File.html#pathSeparator).
- Transformation of URL addresses to platform-specific paths *(to be validated)*<br/>*Example*: **`getLocation.`**[**`getFile`**](https://docs.oracle.com/javase/8/docs/api/java/net/URL.html#getFile) **&rarr;** **`new JFile(url.getFile).getAbsolutePath`**.
- *(more to come)*

## Session examples

#### `setenv.bat`

The [**`setenv`**](setenv.bat) command is executed once to setup our development environment; it makes external tools such as **`javac.exe`**, **`sbt.bat`** and **`git.exe`** directly available from the command prompt:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> setenv
Tool versions:
   javac 1.8.0_191, java 1.8.0_191,
   sbt 1.2.3/2.12.7, git 2.19.1.windows.1, diff 3.6

> where sbt
C:\opt\sbt-1.2.6\bin\sbt
C:\opt\sbt-1.2.6\bin\sbt.bat
</pre>

> **NB.** Execute **`setenv help`** to display the help message.

With option **`-verbose`** the **`setenv`** command also displays the path of the tools:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> setenv -verbose
Tool versions:
   javac 1.8.0_191, java 1.8.0_191,
   sbt 1.2.3/2.12.7, git 2.19.1.windows.1, diff 3.6
Tool paths:
   C:\Program Files\Java\jdk1.8.0_191\bin\javac.exe
   C:\Program Files\Java\jdk1.8.0_191\bin\java.exe
   C:\Program Files (x86)\Common Files\Oracle\Java\javapath\java.exe
   C:\opt\sbt-1.2.6\bin\sbt.bat
   C:\opt\Git-2.19.1\bin\git.exe
   C:\opt\Git-2.19.1\usr\bin\diff.exe
</pre>

#### `build.bat`

The [**`build`**](project/scripts/build.bat) command is a basic build tool consisting of ~400 lines of batch code. 

- **`cleanall`** - This subcommand removes all generated *and untracked* files/directories from our [**`Dotty fork`**](https://github.com/michelou/dotty/blob/master/).<br/>Concretely, **`build cleanall`** executes the two commands **`sbt clean`** *and* [**`git clean -xdf`**](https://git-scm.com/docs/git-clean/) which removes all untracked directories/files, including build products.
<pre style="margin:10px 0 0 30px;font-size:80%;">
> build cleanall
[..]
Removing .vscode/
Removing HelloWorld$.class
Removing HelloWorld.class
Removing HelloWorld.tasty
Removing compiler/target/
Removing dist-bootstrapped/
Removing doc-tool/target/
Removing dotty-bootstrapped/
Removing interfaces/target/
Removing library/target/
Removing out/
Removing project/project/project/
Removing project/project/target/
Removing project/target/
Removing sbt-bridge/target/
Removing scala-compiler/
Removing scala-library/
Removing scala-reflect/
Removing scalap/
Removing setenv.bat
Removing target/
Removing testlogs/
</pre>

- **`compile`** - This subcommand generates the *"1st stage compiler"* for Dotty and executes the relevant test suites. 

<pre style="margin:10px 0 0 30px;font-size:80%;">
&gt; build compile
sbt compile and sbt test
[...]
[info] Done compiling.
[...]
[info] Done packaging.
[...]
[info] Test run started
[info] Test dotty.tools.dottydoc.TestWhitelistedCollections.arrayAndImmutableHasDocumentation started
[info] Test run finished: 0 failed, 0 ignored, 1 total, 21.918s
[info] Test run started
[...]
8 suites passed, 0 failed, 8 total
[...]
[info] Test run started
[...]
2 suites passed, 0 failed, 2 total
[...]
[info] Test run started
[...]
11 suites passed, 0 failed, 11 total
[...]
[info] Test run started
[...]
[info] Passed: Total 73, Failed 0, Errors 0, Passed 73
[info] Passed: Total 290, Failed 0, Errors 0, Passed 288, Skipped 2
[success] Total time: 1063 s, completed 16 nov. 2018 15:39:19
testing sbt dotc and dotr
hello world
testing sbt dotc -from-tasty and dotr -classpath
hello world
testing sbt dotc -decompile
[...]
testing sbt dotr with no -classpath
hello world
testing loading tasty from .tasty file in jar
[...]
</pre>

- **`bootstrap`** - This subcommand generates the *"bootstrap compiler"* for Dotty and executes the relevant test suites ***provided that*** the execution of the **`compile`** subcommand was successful.

<pre style="margin:10px 0 0 30px;font-size:80%;">
&gt; build bootstrap
[...]
</pre>

- **`archives`** - This subcommand generates the gz/zip archives ***provided that*** the execution of the two subcommands **`compile`** and **`bootstrap`** was successful.

<pre style="margin:10px 0 0 30px;font-size:80%;">
&gt; build archives
[...]
</pre>

- **`documentation`** - This subcommand generates the HTML documentation ***provided that*** the execution of the two subcommands **`compile`** and **`bootstrap`** was successful.

<pre style="margin:10px 0 0 30px;font-size:80%;">
&gt; build documentation
[...]
</pre>

<hr style="margin:2em 0 0 0;" />

*[mics](http://lampwww.epfl.ch/~michelou/)/November 2018*
