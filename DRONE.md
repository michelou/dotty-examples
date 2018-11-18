# Building Dotty on Windows

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    The source code of the <a href="http://dotty.epfl.ch/">Dotty project</a> is hosted on <a href="https://github.com/lampepfl/dotty/">Github</a> and continuous delivery is performed by the <a href="https://drone.io/">Drone platform</a> running on the <a href="http://dotty-ci.epfl.ch/lampepfl/dotty">Dotty CI</a> server from <a href="https://lamp.epfl.ch/">LAMP-EPFL</a>.</br>This page describes the additions/changes we made in our <a href="https://github.com/michelou/dotty">fork</a> of the <a href="https://github.com/lampepfl/dotty/">Dotty remote</a> in order to reproduce the same build/test steps on the <b>Microsoft Windows</b> platform.
  </td>
  </tr>
</table>

## Project dependencies

Our <a href="https://github.com/michelou/dotty">Dotty fork</a> depends on three external software for the **Microsoft Windows** platform:

- [Oracle Java 8 SDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) ([*release notes*](http://www.oracle.com/technetwork/java/javase/8u-relnotes-2225394.html))
- [SBT 1.2.6](https://www.scala-sbt.org/download.html) (with Scala 2.12.17 preloaded) ([*release notes*](https://github.com/sbt/sbt/releases/tag/v1.2.6))
- [Git 2.19](https://git-scm.com/download/win) ([*release notes*](https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.19.0.txt))

> ***Installation policy***<br/>
> Whenever possible software is installed via a Zip archive rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in memory of* the [**`/opt/`**](http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) directory on Unix).

For instance our development environment looks as follows (*November 2018*):

<pre style="font-size:80%;">
C:\Program Files\Java\jdk1.8.0_191\
C:\opt\sbt-1.2.6\
C:\opt\Git-2.19.1\
</pre>

## Directory structure

The directory structure of the [Dotty repository](https://github.com/lampepfl/dotty/) is quite complex but fortunately we only have to deal with the three subdirectories [**`bin\`**](https://github.com/michelou/dotty/tree/master/bin), [**`dist\bin\`**](https://github.com/michelou/dotty/tree/master/dist/bin) and [**`project\scripts\`**](https://github.com/michelou/dotty/tree/master/project/scripts).

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

> **NB.** The three directories [**`collection-strawman\`**](https://github.com/dotty-staging/collection-strawman), [**`scala-backend\`**](https://github.com/lampepfl/scala/tree/sharing-backend) and [**`scala2-library\`**](https://github.com/lampepfl/scala/tree/dotty-library2.12) are actually Git submodules (see article ["Mastering Git Submodules"](https://delicious-insights.com/en/posts/mastering-git-submodules/) from [Delicious Insights](https://delicious-insights.com/en/), Jan 8, 2015). Their Git information (e.g. path, URL, branch) is stored in file [**`.gitmodules`**](https://github.com/michelou/dotty/blob/master/.gitmodules).

Concretely directories [**`bin\`**](https://github.com/michelou/dotty/tree/master/bin), [**`dist\bin\`**](https://github.com/michelou/dotty/tree/master/dist/bin), [**`project\scripts\`**](https://github.com/michelou/dotty/tree/master/project/scripts) and the root directory contain the following additions:

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

> **NB.** We also defined a virtual drive **`W:`** In our working environment in order to reduce/hide the real path of our project directory (see [Windows command prompt limitation](https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation)). The Windows external command [**`subst`**](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst) is used to create virtual drives; for instance:<br/>**`> subst W: %USERPROFILE%\workspace`**.

In the next section we give a brief description of the batch scripts present in those directories.

## Batch commands

We distinguish different sets of batch files:

1. [**`setenv.bat`**](https://github.com/michelou/dotty/tree/master/setenv.bat) - This batch command makes external tools such as **`java.exe`**, **`sbt.bat`** and [**`git.exe`**](https://git-scm.com/docs/git) directly available from the command prompt.

    <pre style="font-size:80%;">
    &gt; java -version
    java version "1.8.0_191"
    Java(TM) SE Runtime Environment (build 1.8.0_191-b12)
    Java HotSpot(TM) 64-Bit Server VM (build 25.191-b12, mixed mode)

    &gt; git --version
    git version 2.19.1.windows.1
    </pre>

2. Directory [**`bin\`**](https://github.com/michelou/dotty/tree/master/bin) - This directory contains batch files used internally during the build process.

3. Directory [**`dist\bin\`**](https://github.com/michelou/dotty/tree/master/dist/bin) - This directory contains the shell scripts and batch files to be added unchanged to a [Dotty software release](https://github.com/lampepfl/dotty/releases).

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

4. [**`build.bat`**](https://github.com/michelou/dotty/tree/master/project/scripts/build.bat) - This batch command performs on our local Windows machine build/test steps similar to the ones on the [Dotty CI](http://dotty-ci.epfl.ch/lampepfl/dotty) server.

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

Subcommands obey the following dependency rules for their execution:

| **A** depends on **B** | Execution time<sup>**(1)**</sup> | Output from **A** |
| ------------- | ------------- | ------------- |
| `cleanall` &rarr; *none* | &lt;1 min | &nbsp; |
| `clone` &rarr; *none* | &lt;1 min | &nbsp; |
| `compile` &rarr; `clone` | ~24 min | `compiler\target\`<br/>`library\target`<br/>`sbt-bridge\target\` |
| `compile-only` | ~24 min | &nbsp; |
| `bootstrap` &rarr; `compile` | ~47 min | &nbsp; |
| `archives` &rarr; `bootstrap` | &nbsp; | `dist-bootstrapped\target\*.gz,*.zip` |
| `documentation` &rarr; `bootstrap` | &nbsp; | `docs\_site\*.html`<br/>`docs\docs\*.md` |

<sup>**(1)**</sup> Average time in minutes (measured on a i7-i8550U laptop with 16 GB of memory).

> **NB.** Subcommands whose name ends with **`-only`** help us to execute one single step without running again the precedent ones.


## Windows related issues

In short, we have come across the following issues while executing subcommands of [**`build.bat`**](https://github.com/michelou/dotty/tree/master/project/scripts/build.bat):

| Subcommand | Bug report |
| ---------- | ---------- |
| `compile` | [#5457](https://github.com/lampepfl/dotty/pull/5457) |
| `bootstrap` | *pending* |
| `documentation` | [#5430](https://github.com/lampepfl/dotty/pull/5430) |
| *code review* | [#5452](https://github.com/lampepfl/dotty/pull/5452) |

In summary, we encountered several Windows related issues with the [source code](https://github.com/lampepfl/dotty/) of the [Dotty project](http://dotty.epfl.ch/):

- Unspecified text encoding in some file operations<br/>*Example*: [**`Source`**](https://www.scala-lang.org/api/2.12.7/scala/io/Source$.html)**`.fromFile(f)`** **&rarr;** [**`Source`**](https://www.scala-lang.org/api/2.12.7/scala/io/Source$.html)**`.fromFile(f, "UTF-8")`**.
- Platform-specific new lines<br/>*Example*: **`"\n"`** **&rarr;** **`sys.props("line.separator")`**.
- Platform-specific path separators<br/>*Example*: **`":"`** **&rarr;** [**`java.io.File.pathSeparator`**](https://docs.oracle.com/javase/8/docs/api/java/io/File.html#pathSeparator).
- Special characters in file names<br/>*Example*: **`new PlainFile(Path("<quote>"))`** **&rarr;** **`new PlainFile(Path("_quote_"))`**
- Transformation of URL addresses to platform-specific paths *(to be validated)*<br/>*Example*: **`getLocation.`**[**`getFile`**](https://docs.oracle.com/javase/8/docs/api/java/net/URL.html#getFile) **&rarr;** **`new JFile(url.getFile).getAbsolutePath`**.
- *(more to come)*

## Session examples

#### `setenv.bat`

The [**`setenv`**](https://github.com/michelou/dotty/tree/master/setenv.bat) command is executed once to setup our development environment; it makes external tools such as **`javac.exe`**, **`sbt.bat`** and [**`git.exe`**](https://git-scm.com/docs/git) directly available from the command prompt:

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

With option **`-verbose`** the **`setenv`** command also displays the path of the tools and the current Git branch:

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
Current Git branch:
   master
</pre>

#### `build.bat`

The [**`build`**](https://github.com/michelou/dotty/tree/master/project/scripts/build.bat) command consists of ~400 lines of batch/[Powershell ](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) code and features the following subcommands:

- **`cleanall`** - This subcommand removes all generated *and untracked* files/directories from our [**`Dotty fork`**](https://github.com/michelou/dotty/tree/master/).<br/>Internally, **`build cleanall`** executes the two commands **`sbt clean`** *and* [**`git clean -xdf`**](https://git-scm.com/docs/git-clean/) which removes all untracked directories/files, including build products.
<pre style="margin:10px 0 0 30px;font-size:80%;">
> build cleanall
[...(sbt)...]
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

> **NB.** The following command performs the same operation as **`build compile`**:  
> <pre style="margin:10px 0 0 30px;font-size:80%;">
> > build clone compile-only
> </pre>

- **`bootstrap`** - This subcommand generates the *"bootstrap compiler"* for Dotty and executes the relevant test suites ***if*** the execution of the **`compile`** subcommand was successful.

<pre style="margin:10px 0 0 30px;font-size:80%;">
&gt; build bootstrap
[...]
</pre>

- **`archives`** - This subcommand generates the gz/zip archives ***if*** the execution of the two subcommands **`compile`** and **`bootstrap`** was successful.<br/>Below we execute the **`arch-only`** subcommand for the sake of brievity (previous operations are *assumed* to be successful): 

<pre style="margin:10px 0 0 30px;font-size:80%;">
&gt; build arch-only
[...]

> dir /a-d /b dist-bootstrapped\target
dotty-0.11.0-bin-SNAPSHOT.tar.gz
dotty-0.11.0-bin-SNAPSHOT.zip
</pre>

> **NB.** The following command performs the same operation as **`build archives`**:  
> <pre style="margin:10px 0 0 30px;font-size:80%;">
> > build clone compile-only bootstrap-only archives-only
> </pre>

- **`documentation`** - This subcommand generates the Dotty documentation ([website](https://dotty.epfl.ch/) and [online reference](https://dotty.epfl.ch/docs/)) ***if*** the execution of the two subcommands **`compile`** and **`bootstrap`** was successful.<br/>Below we execute the **`doc-only`** subcommand for the sake of brievity (previous operations are *assumed* to be successful): 

<pre style="margin:10px 0 0 30px;font-size:80%;">
&gt; build -timer doc-only
Working directory: W:\dotty
[...]
[info] Running (fork) dotty.tools.dottydoc.Main -siteroot docs -project Dotty -project-version 0.11.0-bin-SNAPSHOT -project-url https://github.com/lampepfl/dotty ...
Compiling (1/406): AlternateConstructorsPhase.scala
[...]
Compiling (406/406): package.scala
[...]
28 warnings found
there were 3987 feature warning(s); re-run with -feature for details
[doc info] Generating doc page for: dotty.tools.dotc.plugins
[...]
[doc info] Generating doc page for: dotty.tools.dotc.core.unpickleScala2.Scala2Unpickler$.TempPolyType$
================================================================================
Dottydoc summary report for project `Dotty`
================================================================================
Documented members in public API:
[...]
Summary:

public members with docstrings:    5130/14346 (35%)
protected members with docstrings: 162/537 (30%)
================================================================================

Documented members in internal API:
[...]
Summary internal API:

public members with docstrings:    147/588 (25%)
protected members with docstrings: 6/60 (10%)
private members with docstrings:   445/2429 (18%)
total warnings with regards to compilation and documentation: 28
[success] Total time: 143 s, completed 16 nov. 2018 23:07:29
Total execution time: 00:02:34

&gt; dir /b docs\_site
.gitignore
api
blog
css
docs
images
index.html
js
sidebar.yml
versions

&gt; dir /b docs\docs 
contributing       
index.md           
internals          
reference          
release-notes      
resources          
typelevel.md       
usage              
</pre>

<!--
> build -timer compile-only
Total execution time: 00:20:25
-->

<hr style="margin:2em 0 0 0;" />

*[mics](http://lampwww.epfl.ch/~michelou/)/November 2018*
