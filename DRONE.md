# <span id="top">Building Dotty on Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Source code of the <a href="http://dotty.epfl.ch/">Dotty project</a> is hosted on <a href="https://github.com/lampepfl/dotty/">Github</a> and continuous delivery is performed by the <a href="https://drone.io/">Drone platform</a> running on the <a href="http://dotty-ci.epfl.ch/lampepfl/dotty">Dotty CI</a> server from <a href="https://lamp.epfl.ch/">LAMP/EPFL</a>.</br>This page describes changes we made to the source code of the <a href="https://github.com/lampepfl/dotty/">Dotty remote</a> in order to reproduce the same build/test steps locally on a Windows machine.
  </td>
  </tr>
</table>

This page is part of a series of topics related to [Dotty](http://dotty.epfl.ch/) on Windows:

- [Running Dotty on Windows](README.md)
- Building Dotty on Windows
- [Data Sharing and Dotty on Windows](CDS.md)


> **&#9755;** ***Scala CI/CD***<br/>
> Continuous delivery (CD) typically performs the following steps:<br/>&nbsp;&nbsp;&nbsp;Checkout **&rarr;** Compile **&rarr;** Test **&rarr;** Deploy.<br/>
> CI/CD of [Scala](https://www.scala-lang.org/) builds is currently performed by the following cloud services:
>
> - [Jenkins](https://jenkins.io/doc/): the [CI server](https://scala-ci.typesafe.com/) is hosted by [Lightbend](https://en.wikipedia.org/wiki/Lightbend) in San-Francisco, USA (configuration described in [Chef cookbook](https://github.com/scala/scala-jenkins-infra)).<br/>
> - [Travis CI](https://docs.travis-ci.com/user/tutorial/): the [CI server](https://travis-ci.org/scala/scala) is hosted by [Travis CI](https://www.travis-ci.com/) in Berlin, Germany.


## <span id="anchor_01">Project dependencies</span>

Our <a href="https://github.com/michelou/dotty">Dotty fork</a> depends on three external software for the **Microsoft Windows** platform:

- [Oracle Java 8 SDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)<sup id="anchor_01">[[1]](#footnote_01)</sup> ([*release notes*](http://www.oracle.com/technetwork/java/javase/8u-relnotes-2225394.html))
- [SBT 1.2.7](https://www.scala-sbt.org/download.html) (with Scala 2.12.8 preloaded) ([*release notes*](https://github.com/sbt/sbt/releases/tag/v1.2.7))
- [Git 2.20](https://git-scm.com/download/win) ([*release notes*](https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.20.1.txt))

> **&#9755;** ***Installation policy***<br/>
> Whenever possible software is installed via a [Zip archive](https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/) rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [**`/opt/`**](http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) directory on Unix).

For instance our development environment looks as follows (*December 2018*):

<pre style="font-size:80%;">
C:\Program Files\Java\jdk1.8.0_191\
C:\opt\sbt-1.2.7\
C:\opt\Git-2.20.1\
</pre>

> **NB.** Git for Windows provides a BASH emulation used to run [**`git`**](https://git-scm.com/docs/git) from the command line (as well as over 250 Unix commands like [**`awk`**](https://www.linux.org/docs/man1/awk.html), [**`diff`**](https://www.linux.org/docs/man1/diff.html), [**`file`**](https://www.linux.org/docs/man1/file.html), [**`more`**](https://www.linux.org/docs/man1/more.html), [**`mv`**](https://www.linux.org/docs/man1/mv.html), [**`rmdir`**](https://www.linux.org/docs/man1/rmdir.html), [**`sed`**](https://www.linux.org/docs/man1/sed.html) and [**`wc`**](https://www.linux.org/docs/man1/wc.html)).

## Directory structure

The directory structure of the [Dotty repository](https://github.com/lampepfl/dotty/) is quite complex but fortunately we only have to deal with the three subdirectories [**`bin\`**](https://github.com/michelou/dotty/tree/batch-files/bin), [**`dist\bin\`**](https://github.com/michelou/dotty/tree/batch-files/dist/bin) and [**`project\scripts\`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts).

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

> **NB.** The three directories [**`collection-strawman\`**](https://github.com/dotty-staging/collection-strawman), [**`scala-backend\`**](https://github.com/lampepfl/scala/tree/sharing-backend) and [**`scala2-library\`**](https://github.com/lampepfl/scala/tree/dotty-library2.12) are actually Git submodules (see article ["Mastering Git Submodules"](https://delicious-insights.com/en/posts/mastering-git-submodules/) from [Delicious Insights](https://delicious-insights.com/en/)). Their Git information (e.g. path, URL, branch) is stored in file [**`.gitmodules`**](https://github.com/michelou/dotty/blob/master/.gitmodules).

Concretely directories [**`bin\`**](https://github.com/michelou/dotty/tree/batch-files/bin), [**`dist\bin\`**](https://github.com/michelou/dotty/tree/batch-files/dist/bin), [**`project\scripts\`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts) and the root directory contain the following additions:

<pre style="font-size:80%;">
bin\common.bat
bin\dotc.bat
bin\dotd.bat
bin\dotr.bat
dist\bin\common.bat
dist\bin\dotc.bat
dist\bin\dotd.bat
dist\bin\dotr.bat
project\scripts\bootstrapCmdTests.bat
project\scripts\build.bat
project\scripts\cmdTests.bat
project\scripts\common.bat
project\scripts\genDocs.bat
setenv.bat
</pre>

We also define a virtual drive **`W:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"](https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation) from Microsoft Support). We use the Windows external command [**`subst`**](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst) to create virtual drives; for instance:

<pre style="font-size:80%;">
&gt; subst W: %USERPROFILE%\workspace
</pre>

In the next section we give a brief description of the batch files present in those directories.

## Batch commands

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](https://github.com/michelou/dotty/tree/batch-files/setenv.bat) - This batch command makes external tools such as [**`java.exe`**](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html), [**`sbt.bat`**](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html) and [**`git.exe`**](https://git-scm.com/docs/git) directly available from the command prompt.

    <pre style="font-size:80%;">
    > setenv help
    Usage: setenv { options | subcommands }
      Options:
        -verbose         display environment settings
      Subcommands:
        help             display this help message
        update           update repository from remote master
    </pre>

2. Directory [**`bin\`**](https://github.com/michelou/dotty/tree/batch-files/bin) - This directory contains batch files used internally during the build process (see the [**`bootstrapCmdTests`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/bootstrapCmdTests.bat) command).

3. Directory [**`dist\bin\`**](https://github.com/michelou/dotty/tree/batch-files/dist/bin) - This directory contains the shell scripts and batch files to be added unchanged to a [Dotty software release](https://github.com/lampepfl/dotty/releases).

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

4. [**`build.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/build.bat) - This batch command performs on a Windows machine the same build/test steps as specified in file [**`.drone.yml`**](https://github.com/michelou/dotty/blob/master/.drone.yml) and executed on the [Dotty CI](http://dotty-ci.epfl.ch/lampepfl/dotty) server.

    <pre style="font-size:80%;">
    &gt; build help
    Usage: build { options | subcommands }
      Options:
        -timer                 display the total build time
        -verbose               display environment settings
      Subcommands:
        arch[ives]             generate gz/zip archives (after bootstrap)
        boot[strap]            generate+test bootstrapped compiler (after compile)
        cleanall               clean project (sbt+git) and quit
        clone                  update submodules
        compile                generate+test 1st stage compiler (after clone)
        doc[umentation]        generate documentation (after bootstrap)
        help                   display this help message
        sbt                    test sbt-dotty (after bootstrap)
      Advanced subcommands (no deps):
        arch[ives]-only        generate ONLY gz/zip archives
        boot[strap]-only       generate+test ONLY bootstrapped compiler
        compile-only           generate+test ONLY 1st stage compiler
        doc[umentation]-only   generate ONLY documentation
        sbt-only               test ONLY sbt-dotty
    </pre>

    Subcommands obey the following dependency rules for their execution:

    | **A** depends on **B** | Execution time<sup>**(1)**</sup> | Output from **A** |
    | :------------ | :------------: | :------------ |
    | `cleanall` &rarr; &empty; | &lt;1 min | &nbsp; |
    | `clone` &rarr; &empty; | &lt;1 min | &nbsp; |
    | `compile` &rarr; `clone` | ~24 min | `compiler\target\`<br/>`library\target`<br/>`sbt-bridge\target\` |
    | `bootstrap` &rarr; `compile` | ~45 min | &nbsp; |
    | `archives` &rarr; `bootstrap` | &nbsp; | `dist-bootstrapped\target\*.gz,*.zip` |
    | `documentation` &rarr; `bootstrap` | &nbsp; | `docs\_site\*.html`<br/>`docs\docs\*.md` |

    <sub><sup>**(1)**</sup> Average execution time measured on a i7-i8550U laptop with 16 GB of memory.</sub>

    > **NB.** Subcommands whose name ends with **`-only`** help us to execute one single step without running again the precedent ones.
    > 
    | Subcommand | Execution time | Output |
    | :------------ | :------------: | :------------ |
    | `compile-only` | ~24 min | &nbsp; |
    | `bootstrap-only` | ~26 min | &nbsp; |
    | `archives-only`| &lt;1 min | `dist-bootstrapped\target\*.gz,*.zip` |
    | `documentation-only` | &lt;3 min | `docs\_site\*.html`<br/>`docs\docs\*.md` |

5. [**`cmdTests.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/cmdTests.bat) - This batch command performs test steps on a Windows machine in a similar manner to the shell script [**`project\scripts\cmdTests`**](project/scripts/cmdTests) on the [Dotty CI](http://dotty-ci.epfl.ch/lampepfl/dotty) server (see console output in section [**Session examples**](#anchor_02)).

6. [**`bootstrapCmdTests.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/bootstrapCmdTests.bat) - This batch command performs the test steps on a Windows machine in a similar manner to the shell script [**`project\scripts\bootstrapCmdTests`**](project/scripts/bootstrapCmdTests) on the [Dotty CI](http://dotty-ci.epfl.ch/lampepfl/dotty) server.

7. [**`genDocs.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/genDocs.bat) - This batch command generates the Dotty documentation on a Windows machine in a similar manner to the shell script [**`project\script\genDocs`**](project/scripts/genDocs) on the [Dotty CI](http://dotty-ci.epfl.ch/lampepfl/dotty) server.


## Windows related issues

We have come across several Windows related issues while executing subcommands of [**`build.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/build.bat):

| [Pull request](https://github.com/lampepfl/dotty/pulls?q=is%3Apr+author%3Amichelou) | Request status | Context |
| :--------: | :--------: | :--------- |
| [#5587](https://github.com/lampepfl/dotty/pull/5587) | [merged](https://github.com/lampepfl/dotty/commit/172d6a0a1a3a4cbdb0a3ac4741b3f561d1221c40) | **`build bootstrap`** |
| [#5561](https://github.com/lampepfl/dotty/pull/5561) | [merged](https://github.com/lampepfl/dotty/commit/24a2798f51e1cc01d476b9c00ac0e4b925acc8e5) | [**`bootstrapCmdTests`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/bootstrapCmdTests.bat) |
| [#5487](https://github.com/lampepfl/dotty/pull/5487) | [merged](https://github.com/lampepfl/dotty/commit/052c3b1) | **`build bootstrap`** |
| [#5457](https://github.com/lampepfl/dotty/pull/5457) | [merged](https://github.com/lampepfl/dotty/commit/eb175cb) | **`build compile`** |
| [#5452](https://github.com/lampepfl/dotty/pull/5452) | [merged](https://github.com/lampepfl/dotty/commit/7e093b15ff2a927212c7f40aa36b71d0a28f81b5) | Code review |
| [#5444](https://github.com/lampepfl/dotty/pull/5444) | *pending* | Batch commands |
| [#5430](https://github.com/lampepfl/dotty/pull/5430) | [merged](https://github.com/lampepfl/dotty/commit/81b30383800495c64f2c8cfd0979e69e504104bc) | **`build documentation`** |

> **NB.** Related pull requests from other contributors include:<br/>
> <ul><li><a href="https://github.com/lampepfl/dotty/pull/5560">#5560</a> Fix Windows path (<a href="https://github.com/lampepfl/dotty/commit/67c86783ff48723ae96fedeb51c50db62f375042">merged</a>).</li>
> <li><a href="https://github.com/lampepfl/dotty/pull/5531">#5531</a> Test AppVeyor integration.</li></ul>

Below we summarize additions/changes we made to the [source code](https://github.com/lampepfl/dotty/) of the [Dotty project](http://dotty.epfl.ch/):

- Unspecified text encoding in some file operations<br/>*Example*: [**`Source.fromFile(f)`**](https://www.scala-lang.org/api/2.12.7/scala/io/Source$.html) **&rarr;** **`Source.fromFile(f, "UTF-8")`**.
- Platform-specific new lines<br/>*Example*: **`"\n"`** **&rarr;** **`sys.props("line.separator")`**.
- Platform-specific path separators<br/>*Example*: **`":"`** **&rarr;** [**`java.io.File.pathSeparator`**](https://docs.oracle.com/javase/8/docs/api/java/io/File.html#pathSeparator).
- Illegal characters in file names<br/>*Example*: **`new PlainFile(Path("<quote>"))`** **&rarr;** **`new VirtualFile("<quote>")`**
- Transformation of URL addresses to file system paths<br/>*Example*: [**`url.getFile`**](https://docs.oracle.com/javase/8/docs/api/java/net/URL.html#getFile) **&rarr;** **`Paths.get(url.toURI).toString`**.

## <span id="anchor_02">Session examples</span>

#### `setenv.bat`

The **`setenv`** command is executed once to setup our development environment; it makes external tools such as [**`javac.exe`**](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.html), [**`sbt.bat`**](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html) and [**`git.exe`**](https://git-scm.com/docs/git) directly available from the command prompt (see section [**Project dependencies**](#anchor_01)):

<pre style="font-size:80%;">
> setenv
Tool versions:
   javac 1.8.0_191, java 1.8.0_191,
   sbt 1.2.7/2.12.7, git 2.20.1.windows.1, diff 3.6

> where sbt
C:\opt\sbt-1.2.7\bin\sbt
C:\opt\sbt-1.2.7\bin\sbt.bat
</pre>

Command **`setenv -verbose`** also displays the tool paths and the current Git branch:

<pre style="font-size:80%;">
> setenv -verbose
Tool versions:
   javac 1.8.0_191, java 1.8.0_191,
   sbt 1.2.7/2.12.7, git 2.20.1.windows.1, diff 3.6
Tool paths:
   C:\Program Files\Java\jdk1.8.0_191\bin\javac.exe
   C:\Program Files\Java\jdk1.8.0_191\bin\java.exe
   C:\Program Files (x86)\Common Files\Oracle\Java\javapath\java.exe
   C:\opt\sbt-1.2.7\bin\sbt.bat
   C:\opt\Git-2.20.1\bin\git.exe
   C:\opt\Git-2.20.1\usr\bin\diff.exe
Current Git branch:
   master
</pre>

#### `build.bat`

The [**`build`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/build.bat) command consists of ~400 lines of batch/[Powershell ](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) code and features the following subcommands:

- **`cleanall`** - This subcommand removes all generated *and untracked* files/directories from our [**`Dotty fork`**](https://github.com/michelou/dotty/tree/master/).<br/>Internally, **`build cleanall`** executes the two commands **`sbt clean`** *and* [**`git clean -xdf`**](https://git-scm.com/docs/git-clean/) which removes all untracked directories/files, including build products.

    <pre style="font-size:80%;">
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

    Command **`build -verbose cleanall`** also displays the tool paths/options and the current Git branch:

    <pre style="font-size:80%;">
    > build -verbose cleanall
    Tool paths
      GIT_CMD=C:\opt\Git-2.20.1\bin\git.exe
      SBT_CMD=C:\opt\sbt-1.2.7\bin\sbt.bat
    Tool options
      JAVA_OPTS=-Xmx2048m -XX:ReservedCodeCacheSize=2048m -XX:MaxMetaspaceSize=1024m
      SBT_OPTS=-Ddotty.drone.mem=4096m -Dsbt.ivy.home=U:\.ivy2\ -Dsbt.log.noformat=true
    Current Git branch
      url-file [origin/url-file]
    &nbsp;
    [...(sbt)...]
    [...(git)...]
    </pre>

- **`compile`** - This subcommand generates the *"1st stage compiler"* for Dotty and executes the relevant test suites. 

    <pre style="font-size:80%;">
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

    > **:mag_right:** The two commands **`build compile`** and **`build clone compile-only`** perform the same operations.

- **`bootstrap`** - ***If*** execution of the **`compile`** subcommand was successful the **`bootstrap`** subcommand generates the *"bootstrap compiler"* for Dotty and executes the relevant test suites.

    <pre style="font-size:80%;">
    &gt; build bootstrap
    [...]
    </pre>

    > **:mag_right:** The two commands **`build bootstrap`** and **`build compile bootstrap-only`** perform the same operations.

- **`archives`** - ***If*** execution of the **`bootstrap`** subcommand was successful the **`archives`** subcommand generates the gz/zip archives.<br/>Below we execute the **`arch-only`** subcommand for the sake of brievity (previous steps are *assumed* to be successful): 

    <pre style="font-size:80%;">
    &gt; build arch-only
    [...]
    &nbsp;
    > dir /a-d /b dist-bootstrapped\target
    dotty-0.12.0-bin-SNAPSHOT.tar.gz
    dotty-0.12.0-bin-SNAPSHOT.zip
    </pre>

    > **:mag_right:** The two commands **`build archives`** and **`build bootstrap archives-only`** perform the same operations.

- **`documentation`** - ***If*** execution of the **`bootstrap`** subcommand was successful the **`documentation`** subcommand generates the [Dotty website](https://dotty.epfl.ch/) and the online [Dotty documentation](https://dotty.epfl.ch/docs/).<br/>Below we execute the **`doc-only`** subcommand for the sake of brievity (previous operations are *assumed* to be successful): 

    <pre style="font-size:80%;">
    &gt; build -timer doc-only
    Working directory: W:\dotty
    [...]
    [info] Running (fork) dotty.tools.dottydoc.Main -siteroot docs -project Dotty -project-version 0.12.0-bin-SNAPSHOT -project-url https://github.com/lampepfl/dotty ...
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
    &nbsp;
    public members with docstrings:    5181/14606 (35%)
    protected members with docstrings: 164/537 (30%)
    ================================================================================
    &nbsp;
    Documented members in internal API:
    [...]
    Summary internal API:
    &nbsp;
    public members with docstrings:    154/601 (25%)
    protected members with docstrings: 6/60 (10%)
    private members with docstrings:   464/2450 (18%)
    total warnings with regards to compilation and documentation: 29
    [success] Total time: 146 s, completed 29 nov. 2018 11:49:22
    Total execution time: 00:02:36
    </pre>

    > **:mag_right:** The two commands **`build documentation`** and **`build bootstrap documentation-only`** perform the same operations.

    Output directory **`docs\_site\`** contains the files of the online [Dotty documentation](https://dotty.epfl.ch/docs/):

    <pre style="font-size:80%;">
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
    &gt; dir /a-d /b /s docs\_site\*.html | wc -l
    2551
    &gt; dir /a-d /b /s docs\_site\*.jpg docs\_site\*.png docs\_site\*.svg | wc -l
    23
    &gt; dir /a-d /b /s docs\_site\*.js | wc -l
    9
    </pre>

    Output directory **`docs\docs\`** contains the Markdown files of the [Dotty website](https://dotty.epfl.ch/):

    <pre style="font-size:80%;">
    &gt; dir /b docs\docs
    contributing
    index.md  
    internals 
    reference 
    release-notes
    resources   
    typelevel.md
    usage
    &gt; dir /a-d /b /s docs\docs\*.md | wc -l
    88 
    </pre>

<!--
> build -timer compile-only
Total execution time: 00:20:25
-->

#### `cmdTests`

The [**`cmdTests`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/cmdTests.bat) command performs several tests running Dotty commands from [**`sbt`**](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html).

<pre style="font-size:80%;">
&gt; cmdTests
testing sbt dotc and dotr
hello world
testing sbt dotc -from-tasty and dotr -classpath
hello world
testing sbt dotc -decompile
[info] Loading project definition from W:\dotty\project\project
[info] Loading project definition from W:\dotty\project
  def main(args: scala.Array[scala.Predef.String]): scala.Unit = scala.Predef.println("hello world")
testing sbt dotc -decompile from file
[info] Loading project definition from W:\dotty\project\project
[info] Loading project definition from W:\dotty\project
  def main(args: scala.Array[scala.Predef.String]): scala.Unit = scala.Predef.println("hello world")
testing sbt dotr with no -classpath
hello world
testing loading tasty from .tasty file in jar
[info] Loading project definition from W:\dotty\project\project
[info] Loading project definition from W:\dotty\project
  def main(args: scala.Array[scala.Predef.String]): scala.Unit = scala.Predef.println("hello world")
</pre>

#### `bootstrapCmdTests`

The [**`bootstrapCmdTests`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/bootstrapCmdTests.bat) command performs several benchmarks and generates the documentation page for the [**`tests\pos\HelloWorld.scala`**](https://github.com/michelou/dotty/tree/master/tests/pos/HelloWorld.scala) program.

<pre style="font-size:80%;">
&gt; bootstrapCmdTests
[...]
[info] Updating dotty-bench...
[...]
[info] Running (fork) dotty.tools.benchmarks.Bench 1 1 tests/pos/alias.scala
# JMH version: 1.19
# VM version: JDK 1.8.0_191, VM 25.191-b12
# VM invoker: C:\Progra~1\Java\jdk1.8.0_191\jre\bin\java.exe
# VM options: -Xms2G -Xmx2G
# Warmup: 1 iterations, 1 s each
# Measurement: 1 iterations, 1 s each
# Timeout: 10 min per iteration
# Threads: 1 thread, will synchronize iterations
# Benchmark mode: Average time, time/op
# Benchmark: dotty.tools.benchmarks.Worker.compile

# Run progress: 0.00% complete, ETA 00:00:02
# Fork: 1 of 1
# Warmup Iteration   1: 3011.972 ms/op
Iteration   1: 533.625 ms/op


Result "dotty.tools.benchmarks.Worker.compile":
  533.625 ms/op


# Run complete. Total time: 00:00:05

Benchmark       Mode  Cnt    Score   Error  Units
Worker.compile  avgt       533.625          ms/op
[success] Total time: 21 s, completed 3 déc. 2018 09:44:07
[...]
[info] Updating dotty-bench-bootstrapped...
[...]
[info] Running (fork) dotty.tools.benchmarks.Bench 1 1 tests/pos/alias.scala
# JMH version: 1.19
# VM version: JDK 1.8.0_191, VM 25.191-b12
# VM invoker: C:\Progra~1\Java\jdk1.8.0_191\jre\bin\java.exe
# VM options: -Xms2G -Xmx2G
# Warmup: 1 iterations, 1 s each
# Measurement: 1 iterations, 1 s each
# Timeout: 10 min per iteration
# Threads: 1 thread, will synchronize iterations
# Benchmark mode: Average time, time/op
# Benchmark: dotty.tools.benchmarks.Worker.compile

# Run progress: 0.00% complete, ETA 00:00:02
# Fork: 1 of 1
# Warmup Iteration   1: 2359.948 ms/op
Iteration   1: 361.619 ms/op


Result "dotty.tools.benchmarks.Worker.compile":
  361.619 ms/op


# Run complete. Total time: 00:00:04

Benchmark       Mode  Cnt    Score   Error  Units
Worker.compile  avgt       361.619          ms/op
[success] Total time: 21 s, completed 3 déc. 2018 09:44:42
[...]
[info] Running (fork) dotty.tools.benchmarks.Bench 1 1 -with-compiler compiler/src/dotty/tools/dotc/core/Types.scala
# JMH version: 1.19
# VM version: JDK 1.8.0_191, VM 25.191-b12
# VM invoker: C:\Progra~1\Java\jdk1.8.0_191\jre\bin\java.exe
# VM options: -Xms2G -Xmx2G
# Warmup: 1 iterations, 1 s each
# Measurement: 1 iterations, 1 s each
# Timeout: 10 min per iteration
# Threads: 1 thread, will synchronize iterations
# Benchmark mode: Average time, time/op
# Benchmark: dotty.tools.benchmarks.Worker.compile

# Run progress: 0.00% complete, ETA 00:00:02
# Fork: 1 of 1
# Warmup Iteration   1: 13858.101 ms/op
Iteration   1: 5828.334 ms/op


Result "dotty.tools.benchmarks.Worker.compile":
  5828.334 ms/op


# Run complete. Total time: 00:00:20

Benchmark       Mode  Cnt     Score   Error  Units
Worker.compile  avgt       5828.334          ms/op
[success] Total time: 28 s, completed 3 déc. 2018 09:45:23
testing scala.quoted.Expr.run from sbt dotr
[...]
[info] [dist-bootstrapped] Creating a distributable package in dist-bootstrapped\target\pack
[...]
[info] [dist-bootstrapped] done.
[success] Total time: 8 s, completed 3 déc. 2018 09:46:13
testing ./bin/dotc and ./bin/dotr
testing ./bin/dotc -from-tasty and dotr -classpath
testing ./bin/dotd
Compiling (1/1): HelloWorld.scala
[doc info] Generating doc page for: <empty>
[doc info] Generating doc page for: <empty>.HelloWorld$
[doc info] Generating doc page for: <empty>.HelloWorld$
[...]
public members with docstrings:    0
protected members with docstrings: 0
private members with docstrings:   0
</pre>

#### `genDocs`

The [**`genDocs`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/genDocs.bat) command generates the documentation page for the [**`tests\pos\HelloWorld.scala`**](https://github.com/michelou/dotty/tree/master/tests/pos/HelloWorld.scala) program.

<pre style="font-size:80%;">
&gt; genDocs    
Working directory: W:\dotty
[..(sbt)..]       
[info] Running (fork) dotty.tools.dottydoc.Main -siteroot docs -project Dotty -project-version 
OT -project-url https://github.com/lampepfl/dotty -classpath ...
[...]
Summary:

public members with docstrings:    5187/14614 (35%)
protected members with docstrings: 165/538 (30%)
================================================================================
[...]
Summary internal API:

public members with docstrings:    156/604 (25%)
protected members with docstrings: 6/60 (10%)
private members with docstrings:   466/2454 (18%)
total warnings with regards to compilation and documentation: 29
[success] Total time: 135 s, completed 3 déc. 2018 15:05:04
</pre>

## Footnotes

<a name="footnote_01">[1]</a> ***2018-11-18*** [↩](#anchor_01)

<div style="margin:0 0 1em 20px;">
Oracle annonces in his <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">Java SE Support Roadmap</a> he will stop public updates of Java SE 8 for commercial use after January 2019. Launched in March 2014 Java SE 8 is classified an LTS release in the new time-based system and <a href="https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html">Java SE 11</a>, released in September 2018, is the next LTS release.
</div>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/December 2018* [**&#9650;**](#top)

