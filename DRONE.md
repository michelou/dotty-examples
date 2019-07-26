# <span id="top">Building Dotty on Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:80px;">
    <a href="http://dotty.epfl.ch/"><img style="border:0;width:80px;" src="docs/dotty.png" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Source code of the <a href="http://dotty.epfl.ch/">Dotty project</a> is hosted on <a href="https://github.com/lampepfl/dotty/">Github</a> and continuous delivery is performed by the <a href="https://drone.io/">Drone platform</a> running on the <a href="http://dotty-ci.epfl.ch/lampepfl/dotty">Dotty CI</a> server from <a href="https://lamp.epfl.ch/">LAMP/EPFL</a>.</br>This page describes changes we made to the source code of the <a href="https://github.com/lampepfl/dotty/">Dotty remote</a> in order to reproduce the same build/test steps locally on a Windows machine.
  </td>
  </tr>
</table>

This page is part of a series of topics related to [Dotty](http://dotty.epfl.ch/) on Windows:

- [Running Dotty on Windows](README.md)
- Building Dotty on Windows [**&#9660;**](#bottom)
- [Data Sharing and Dotty on Windows](CDS.md)
- [OpenJDK and Dotty on Windows](OPENJDK.md)

[JMH](https://openjdk.java.net/projects/code-tools/jmh/), [Tasty](https://www.scala-lang.org/blog/2018/04/30/in-a-nutshell.html) and [GraalVM](https://www.graalvm.org/) are other topics we are currently investigating.

> **&#9755;** ***Continuous Integration/Delivery*** (CI/CD)<br/>
> (steps: Checkout **&rarr;** Compile **&rarr;** Test **&rarr;** Deploy)
> 
> | Software | CI/CD&nbsp;service | Hosting |
> | :------: | :------------ | :------ |
> | [Dotty](http://dotty-ci.epfl.ch/lampepfl/dotty) | [Drone](https://drone.io/) <sup>**(1)**</sup> | [EPFL](http://dotty-ci.epfl.ch/lampepfl/dotty) in Lausanne, Switzerland |
> | [Scala](https://www.scala-lang.org/) | [Jenkins](https://jenkins.io/doc/) <sup>**(2)**</sup><br/>[Travis CI](https://docs.travis-ci.com/user/tutorial/) <sup>**(3)**</sup> | [Lightbend ](https://scala-ci.typesafe.com/) in San-Francisco, USA<br/>[Travis](https://travis-ci.org/scala/scala) in Berlin, Germany
> | [Oracle&nbsp;OpenJDK](https://ci.adoptopenjdk.net/) | [Jenkins](https://jenkins.io/doc/) <sup>**(2)**</sup> | Oracle |
> | [IBM OpenJ9](https://ci.eclipse.org/openj9/) | [Jenkins](https://jenkins.io/doc/) <sup>**(2)**</sup> | IBM |
>
> <sub><sup>**(1)**</sup> Written in [Go](https://github.com/drone/drone), <sup>**(2)**</sup> Written in [Java](https://www.oracle.com/technetwork/java/index.html), <sup>**(3)**</sup> Written in [Ruby](https://www.ruby-lang.org/en/).</sub>


## <span id="section_01">Project dependencies</span>

Our <a href="https://github.com/michelou/dotty">Dotty fork</a> depends on three external software for the **Microsoft Windows** platform:

- [Oracle OpenJDK 8](https://adoptopenjdk.net/?variant=openjdk8&jvmVariant=hotspot)<sup id="anchor_02">[[1]](#footnote_01)</sup> ([*release notes*](https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-April/009115.html))
- [SBT 1.2.8](https://www.scala-sbt.org/download.html) (requires Java 8) ([*release notes*](https://github.com/sbt/sbt/releases/tag/v1.2.8))
- [Git 2.22](https://git-scm.com/download/win) ([*release notes*](https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.22.0.txt))

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive](https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/) rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [**`/opt/`**](http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) directory on Unix).

For instance our development environment looks as follows (*July 2019*):

<pre style="font-size:80%;">
C:\opt\jdk-1.8.0_222-b10\
C:\opt\sbt-1.2.8\
C:\opt\Git-2.22.0\
</pre>

> **:mag_right:** [Git for Windows](https://git-scm.com/) provides a BASH emulation used to run [**`git`**](https://git-scm.com/docs/git) from the command line (as well as over 250 Unix commands like [**`awk`**](https://www.linux.org/docs/man1/awk.html), [**`diff`**](https://www.linux.org/docs/man1/diff.html), [**`file`**](https://www.linux.org/docs/man1/file.html), [**`grep`**](https://www.linux.org/docs/man1/grep.html), [**`more`**](https://www.linux.org/docs/man1/more.html), [**`mv`**](https://www.linux.org/docs/man1/mv.html), [**`rmdir`**](https://www.linux.org/docs/man1/rmdir.html), [**`sed`**](https://www.linux.org/docs/man1/sed.html) and [**`wc`**](https://www.linux.org/docs/man1/wc.html)).

## Directory structure

The directory structure of the [Dotty repository](https://github.com/lampepfl/dotty/) is quite complex but fortunately we only have to deal with the three subdirectories [**`bin\`**](https://github.com/michelou/dotty/tree/batch-files/bin), [**`dist\bin\`**](https://github.com/michelou/dotty/tree/batch-files/dist/bin) and [**`project\scripts\`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts).

<pre style="font-size:80%;">
<b>&gt; dir /ad /b</b>
.git
.vscode-template
AUTHORS.md, CONTRIBUTING.md, LICENSE.md, README.md
bench
bin
community-build
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
scalastyle-config.xml
semanticdb
tests
vscode-dotty
</pre>

<!-- 2019-02-13
> **:mag_right:** Directories like [**`scala-backend\`**](https://github.com/lampepfl/scala/tree/sharing-backend), [**`scala2-library\`**](https://github.com/lampepfl/scala/tree/dotty-library2.12) and **`community-build`** subdirectories are actually Git submodules (see article ["Mastering Git Submodules"](https://delicious-insights.com/en/posts/mastering-git-submodules/) from [Delicious Insights](https://delicious-insights.com/en/)). Their Git information (e.g. path, URL, branch) is stored in file [**`.gitmodules`**](https://github.com/michelou/dotty/blob/master/.gitmodules).
-->
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

We also define a virtual drive **`W:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"](https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation) from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst) to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; subst W: %USERPROFILE%\workspace</b>
> </pre>

In the next section we give a brief description of the batch files present in those directories.

## Batch commands

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](https://github.com/michelou/dotty/tree/batch-files/setenv.bat) - This batch command makes external tools such as [**`java.exe`**](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html), [**`sbt.bat`**](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html) and [**`git.exe`**](https://git-scm.com/docs/git) directly available from the command prompt (see section [**Project dependencies**](#section_01)).

    <pre style="font-size:80%;">
    <b>&gt; setenv help</b>
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
    <b>&gt; dir /b .\dist\bin</b>
    common
    common.bat
    dotc
    dotc.bat
    dotd
    dotd.bat
    dotr
    dotr.bat
    </pre>

4. [**`build.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/build.bat) - This batch command performs on a Windows machine the same build/test steps as specified in file [**`.drone.yml`**](https://github.com/michelou/dotty/blob/master/.drone.yml) and executed on the [Dotty CI](http://dotty-ci.epfl.ch/lampepfl/dotty) server.

    <pre style="font-size:80%;">
    <b>&gt; build help</b>
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
        community              test community-build
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
    | `community` &rarr; &empty; | &nbsp; | &nbsp; |
    | `archives` &rarr; `bootstrap` | &nbsp; | `dist-bootstrapped\target\*.gz,*.zip` |
    | `documentation` &rarr; `bootstrap` | &nbsp; | `docs\_site\*.html`<br/>`docs\docs\*.md` |
    | `sbt` &rarr; `bootstrap` | &nbsp; | &nbsp; |
    
    <sub><sup>**(1)**</sup> Average execution time measured on a i7-i8550U laptop with 16 GB of memory.</sub>

    > **:mag_right:** Subcommands whose name ends with **`-only`** help us to execute one single step without running again the precedent ones. They are listed as *Advanced subcommands* by command **`build help`** and should ***never*** be used in an automatic build.
    > 
    > | Subcommand | Execution time | Output |
    > | :------------ | :------------: | :------------ |
    > | `compile-only` | ~24 min | &nbsp; |
    > | `bootstrap-only` | ~26 min | &nbsp; |
    > | `archives-only`| &lt;1 min | `dist-bootstrapped\target\*.gz,*.zip` |
    > | `documentation-only` | &lt;3 min | `docs\_site\*.html`<br/>`docs\docs\*.md` |
    > | `sbt-only` | &nbsp; | &nbsp; |
    >
    > In particular we have the following equivalences:
    > 
    > | Command | Equivalent command |
    > | :------ | :----------------- |
    > | **`build compile`** | **`build clone compile-only`** |
    > | **`build bootstrap`** | **`build compile bootstrap-only`** |
    > | **`build archives`** | **`build bootstrap archives-only`** |
    > | **`build documentation`** | **`build bootstrap documentation-only`** |
    > | **`build sbt`** | **`build bootstrap sbt-only`** |

5. [**`cmdTests.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/cmdTests.bat) - This batch command performs test steps on a Windows machine in a similar manner to the shell script [**`project\scripts\cmdTests`**](project/scripts/cmdTests) on the [Dotty CI](http://dotty-ci.epfl.ch/lampepfl/dotty) server (see console output in section [**Usage examples**](#section_05)).

6. [**`bootstrapCmdTests.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/bootstrapCmdTests.bat) - This batch command performs the test steps on a Windows machine in a similar manner to the shell script [**`project\scripts\bootstrapCmdTests`**](project/scripts/bootstrapCmdTests) on the [Dotty CI](http://dotty-ci.epfl.ch/lampepfl/dotty) server.

7. [**`genDocs.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/genDocs.bat) - This batch command generates the Dotty documentation on a Windows machine in a similar manner to the shell script [**`project\script\genDocs`**](project/scripts/genDocs) on the [Dotty CI](http://dotty-ci.epfl.ch/lampepfl/dotty) server.


## Windows related issues

We have come across several Windows related issues while executing subcommands of [**`build.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/build.bat):

| [Pull request](https://github.com/lampepfl/dotty/pulls?q=is%3Apr+author%3Amichelou) | Request status | Context |
| :--------: | :--------: | :--------- |
| [#6653](https://github.com/lampepfl/dotty/pull/6653) | [merged](https://github.com/lampepfl/dotty/commit/fe02bf4fdc14f648b5f42731e39448995963256c) | Batch commands |
| [#5814](https://github.com/lampepfl/dotty/pull/5814) | [merged](https://github.com/lampepfl/dotty/commit/923fb06dc625e054e8b1833d4b7db49d369d91ad) | **`build compile`** |
| [#5659](https://github.com/lampepfl/dotty/pull/5659) | [merged](https://github.com/lampepfl/dotty/commit/7b9ffbb56b2bd33efead1c0f38a71c057c31463e) | **`build bootstrap`** |
| [#5587](https://github.com/lampepfl/dotty/pull/5587) | [merged](https://github.com/lampepfl/dotty/commit/172d6a0a1a3a4cbdb0a3ac4741b3f561d1221c40) | **`build bootstrap`** |
| [#5561](https://github.com/lampepfl/dotty/pull/5561) | [merged](https://github.com/lampepfl/dotty/commit/24a2798f51e1cc01d476b9c00ac0e4b925acc8e5) | **`build bootstrap`** |
| [#5487](https://github.com/lampepfl/dotty/pull/5487) | [merged](https://github.com/lampepfl/dotty/commit/052c3b1) | **`build bootstrap`** |
| [#5457](https://github.com/lampepfl/dotty/pull/5457) | [merged](https://github.com/lampepfl/dotty/commit/eb175cb) | **`build compile`** |
| [#5452](https://github.com/lampepfl/dotty/pull/5452) | [merged](https://github.com/lampepfl/dotty/commit/7e093b15ff2a927212c7f40aa36b71d0a28f81b5) | Code review |
| [#5444](https://github.com/lampepfl/dotty/pull/5444) | *pending* | Batch commands |
| [#5430](https://github.com/lampepfl/dotty/pull/5430) | [merged](https://github.com/lampepfl/dotty/commit/81b30383800495c64f2c8cfd0979e69e504104bc) | **`build documentation`** |

> **&#9755;** Related pull requests from other contributors include:<br/>
> <ul><li><a href="https://github.com/lampepfl/dotty/pull/5560">#5560</a> Fix Windows path (<a href="https://github.com/lampepfl/dotty/commit/67c86783ff48723ae96fedeb51c50db62f375042">merged</a>).</li>
> <li><a href="https://github.com/lampepfl/dotty/pull/5531">#5531</a> Test AppVeyor integration (<a href="https://github.com/lampepfl/dotty/pull/5531#issuecomment-446505630">closed</a>).</li></ul>

Below we summarize changes we made to the [source code](https://github.com/lampepfl/dotty/) of the [Dotty project](http://dotty.epfl.ch/):

- Unspecified character encoding in some file operations<br/>*Example*: [**`Source.fromFile(f)`**](https://www.scala-lang.org/api/2.12.7/scala/io/Source$.html) **&rarr;** **`Source.fromFile(f, "UTF-8")`**.
- Platform-specific new lines<br/>*Example*: **`"\n"`** **&rarr;** [**`System.lineSeparator`**](https://docs.oracle.com/javase/8/docs/api/java/lang/System.html#lineSeparator).
- Platform-specific path separators<br/>*Example*: **`":"`** **&rarr;** [**`java.io.File.pathSeparator`**](https://docs.oracle.com/javase/8/docs/api/java/io/File.html#pathSeparator).
- Illegal characters in file names<br/>*Example*: **`new PlainFile(Path("<quote>"))`** **&rarr;** **`new VirtualFile("<quote>")`**
- Transformation of URL addresses to file system paths<br/>*Example*: [**`url.getFile`**](https://docs.oracle.com/javase/8/docs/api/java/net/URL.html#getFile) **&rarr;** **`Paths.get(url.toURI).toString`**.
- Unspecified character encoding when piping stdout<br/>*Example*: **`new InputStreamReader(process.getInputStream)`** **&rarr;** **`new InputStreamReader(process.getInputStream, "UTF-8")`**<br/>where **`process`** has type [**`ProcessBuilder`**](https://docs.oracle.com/javase/8/docs/api/java/lang/ProcessBuilder.html).

## <span id="section_05">Usage examples</span>

#### `setenv.bat`

Command **`setenv`** is executed once to setup our development environment; it makes external tools such as [**`javac.exe`**](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.html), [**`sbt.bat`**](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html) and [**`git.exe`**](https://git-scm.com/docs/git) directly available from the command prompt (see section [**Project dependencies**](#section_01)):

<pre style="font-size:80%;">
<b>&gt; setenv</b>
Tool versions:
   javac 1.8.0_222, java 1.8.0_222,
   sbt 1.2.8/2.12.8, git 2.22.0.windows.1, diff 3.7

<b>&gt; where sbt</b>
C:\opt\sbt-1.2.8\bin\sbt
C:\opt\sbt-1.2.8\bin\sbt.bat
</pre>

Command **`setenv -verbose`** also displays the tool paths and the current Git branch:

<pre style="font-size:80%;">
<b>&gt; setenv -verbose</b>
Tool versions:
   javac 1.8.0_222, java 1.8.0_222,
   sbt 1.2.8/2.12.8, git 2.22.0.windows.1, diff 3.7
Tool paths:
   C:\opt\jdk-1.8.0_222-b10\bin\javac.exe
   C:\opt\jdk-1.8.0_222-b10\bin\java.exe
   C:\ProgramData\Oracle\Java\javapath\java.exe
   C:\Program Files (x86)\Common Files\Oracle\Java\javapath\java.exe
   C:\opt\sbt-1.2.8\bin\sbt.bat
   C:\opt\Git-2.22.0\bin\git.exe
   C:\opt\Git-2.22.0\usr\bin\diff.exe
Current Git branch:
   master
</pre>

#### `build.bat`

Command [**`build`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/build.bat) consists of ~400 lines of batch/[Powershell ](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) code and features the following subcommands:

- **`cleanall`** - This subcommand removes all generated *and untracked* files/directories from our [**`Dotty fork`**](https://github.com/michelou/dotty/tree/master/).<br/>Internally, **`build cleanall`** executes the two commands **`sbt clean`** *and* [**`git clean -xdf`**](https://git-scm.com/docs/git-clean/) which removes all untracked directories/files, including build products.

    <pre style="font-size:80%;">
    <b>&gt; build cleanall</b>
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
    <b>&gt; build -verbose cleanall</b>
    Tool paths
      GIT_CMD=C:\opt\Git-2.22.0\bin\git.exe
      JAVA_CMD=C:\opt\jdk-1.8.0_222-b10\bin\java.exe
      SBT_CMD=C:\opt\sbt-1.2.8\bin\sbt.bat
    Tool options
      JAVA_OPTS=-Xmx2048m -XX:ReservedCodeCacheSize=2048m -XX:MaxMetaspaceSize=1024m
      SBT_OPTS=-Ddotty.drone.mem=4096m -Dsbt.ivy.home=U:\.ivy2\ -Dsbt.log.noformat=true
    Current Git branch
      master
    &nbsp;
    [...(sbt)...]
    [...(git)...]
    </pre>

- **`compile`** - This subcommand generates the *"1st stage compiler"* for [Dotty](http://dotty.epfl.ch/) and executes the relevant test suites. 

    <pre style="font-size:80%;">
    <b>&gt; build compile</b>
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

- **`bootstrap`** - ***If*** execution of the **`compile`** subcommand was successful the **`bootstrap`** subcommand generates the *"bootstrap compiler"* for Dotty and executes the relevant test suites.

    <pre style="font-size:80%;">
    <b>&gt; build bootstrap</b>
    [...]
    </pre>

- **`community`** - Subcommand **`community`** generates subprojects from **`community-build\community-projects\`**: 

    <pre style="font-size:80%;">
    <b>&gt; build community</b>
    [...]
    </pre>

- **`archives`** - ***If*** execution of the **`bootstrap`** subcommand was successful the **`archives`** subcommand generates the gz/zip archives.<br/>Below we execute the **`arch-only`** subcommand for the sake of brievity (previous steps are *assumed* to be successful): 

    <pre style="font-size:80%;">
    <b>&gt; build arch-only</b>
    [...]
    &nbsp;
    <b>&gt; dir /a-d /b dist-bootstrapped\target</b>
    dotty-0.17.0-bin-SNAPSHOT.tar.gz
    dotty-0.17.0-bin-SNAPSHOT.zip
    </pre>

- **`documentation`** - ***If*** execution of the **`bootstrap`** subcommand was successful the **`documentation`** subcommand generates the [Dotty website](https://dotty.epfl.ch/) and the online [Dotty documentation](https://dotty.epfl.ch/docs/).<br/>Below we execute the **`doc-only`** subcommand for the sake of brievity (previous operations are *assumed* to be successful): 

    <pre style="font-size:80%;">
    <b>&gt; build -timer doc-only</b>
    Working directory: W:\dotty
    [...]
    [info] Running (fork) dotty.tools.dottydoc.Main -siteroot docs -project Dotty -project-version 0.15.0-bin-SNAPSHOT -project-url https://github.com/lampepfl/dotty ...
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

    Output directory **`docs\_site\`** contains the files of the online [Dotty documentation](https://dotty.epfl.ch/docs/):

    <pre style="font-size:80%;">
    <b>&gt; dir /b docs\_site</b>
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
    <b>&gt; dir /a-d /b /s docs\_site\*.html | wc -l</b>
    2551
    <b>&gt; dir /a-d /b /s docs\_site\*.jpg docs\_site\*.png docs\_site\*.svg | wc -l</b>
    23
    <b>&gt; dir /a-d /b /s docs\_site\*.js | wc -l</b>
    9
    </pre>

    Output directory **`docs\docs\`** contains the Markdown files of the [Dotty website](https://dotty.epfl.ch/):

    <pre style="font-size:80%;">
    <b>&gt; dir /b docs\docs</b>
    contributing
    index.md  
    internals 
    reference 
    release-notes
    resources   
    typelevel.md
    usage
    <b>&gt; dir /a-d /b /s docs\docs\*.md | wc -l</b>
    88 
    </pre>

<!--
> build -timer compile-only
Total execution time: 00:20:25
-->

#### `cmdTests`

Command [**`project\scripts\cmdTests`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/cmdTests.bat) performs several tests running Dotty commands from [**`sbt`**](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html). In the normal case, command [**`cmdTests`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/cmdTests.bat) is called by command **`build compile`** but may also be called directly.


<pre style="font-size:80%;">
<b>&gt; cmdTests</b>
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

Command [**`project\scripts\bootstrapCmdTests`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/bootstrapCmdTests.bat) performs several benchmarks and generates the documentation page for the [**`tests\pos\HelloWorld.scala`**](https://github.com/michelou/dotty/tree/master/tests/pos/HelloWorld.scala) program. In the normal case, command [**`bootstrapCmdTests`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/bootstrapCmdTests.bat) is called by command **`build bootstrap`** but may also be called directly.

<pre style="font-size:80%;">
<b>&gt; bootstrapCmdTests</b>
[...]
[info] Updating dotty-bench...
[...]
[info] Running (fork) dotty.tools.benchmarks.Bench 1 1 tests/pos/alias.scala
# JMH version: 1.21
# VM version: JDK 1.8.0_222, VM 25.222-b10
# VM invoker: C:\opt\jdk-1.8.0_222-b10\bin\java.exe
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
# JMH version: 1.21
# VM version: JDK 1.8.0_222, VM 25.222-b10
# VM invoker: C:\opt\jdk-1.8.0_222-b10\bin\java.exe
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
# JMH version: 1.21
# VM version: JDK 1.8.0_222, VM 25.222-b10
# VM invoker: C:\opt\jdk-1.8.0_222-b10\bin\java.exe
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

Command [**`genDocs`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/genDocs.bat) generates the documentation page for the [**`tests\pos\HelloWorld.scala`**](https://github.com/michelou/dotty/tree/master/tests/pos/HelloWorld.scala) program.

<pre style="font-size:80%;">
<b>&gt; genDocs</b>
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

<a name="footnote_01">[1]</a> ***2018-11-18*** [↩](#anchor_02)

<div style="margin:0 0 1em 20px;">
Oracle annonces in his <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">Java SE Support Roadmap</a> he will stop public updates of Java SE 8 for commercial use after January 2019. Launched in March 2014 Java SE 8 is classified an <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">LTS</a> release in the new time-based system and <a href="https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html">Java SE 11</a>, released in September 2018, is the current LTS release.<br/><i>(see also <a href="https://www.slideshare.net/HendrikEbbers/java-11-omg">Java 11 keynote</a> from <a href="https://www.jvm-con.de/speakers/#/speaker/3461-hendrik-ebbers">Hendrik Ebbers</a> at <a href="https://www.jvm-con.de/ruckblick/">JVM-Con 2018</a>)<i>
</div>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/July 2019* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>
