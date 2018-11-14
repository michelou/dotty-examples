# Building Dotty on Windows

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    The source code of the <a href="http://dotty.epfl.ch/">Dotty project</a> is hosted on <a href="https://github.com/lampepfl/dotty/">Github</a> and continuous delivery is achieved by the <a href="https://drone.io/">Drone platform</a> hosted on an <a href="http://lampsrv9.epfl.ch/lampepfl/dotty/">EPFL server</a>.</br>This page describes the additions/changes we made in our <a href="https://github.com/michelou/dotty">fork</a> of the <a href="https://github.com/lampepfl/dotty/">Dotty remote</a> in order to reproduce the same build/test steps on the <b>Microsoft Windows</b> platform.
  </td>
  </tr>
</table>

## Project dependencies

Our <a href="https://github.com/michelou/dotty">Dotty fork</a> relies on three external software for the **Microsoft Windows** platform:

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

Directories **`bin\`**, **`dist\bin\`**, **`project\scripts\`** and the root directory contain the following additions:

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

2. Directory [**`bin\`** ](https://github.com/michelou/dotty/tree/master/bin) - This directory contains the batch files used internally during the build process.

3. Directory [**`dist\bin\`** ](https://github.com/michelou/dotty/tree/master/dist/bin) - This directory contains the batch files to be added unchanged to a [Dotty software release](https://github.com/lampepfl/dotty/releases).

    <pre style="font-size:80%;">
    &gt; dir /b .\bin
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

4. [**`build.bat`**](https://github.com/michelou/dotty/blob/master/project/scripts/build.bat) - This batch script performs similar build/test steps as on the <a href="http://lampsrv9.epfl.ch/lampepfl/dotty/">EPFL server</a> on a local Windows machine.

    <pre style="font-size:80%;">
    &gt; build help
    Usage: build { options | subcommands }
      Options:
        -verbose               display environment settings
      Subcommands:
        arch[ives]             generate gz/zip archives (after bootstrap)
        arch[ives]-only        generate ONLY gz/zip archives
        boot[strap]            generate compiler bootstrap (after build)
        boot[strap]-only       generate ONLY compiler bootstrap
        cleanall               clean project (sbt+git) and quit
        doc[umentation]        generate documentation (after bootstrap)
        doc[umentation]-only]  generate ONLY documentation
        help                   display this help message
</pre>

<hr style="margin:2em 0 0 0;" />

*[mics](http://lampwww.epfl.ch/~michelou/)/November 2018*
