# <span id="top">Building Dotty on Windows</span> <span style="size:25%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:80px;">
    <a href="http://dotty.epfl.ch/"><img style="border:0;width:80px;" src="docs/dotty.png" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Source code of the <a href="http://dotty.epfl.ch/">Dotty project</a> is hosted on <a href="https://github.com/lampepfl/dotty/">Github</a> and continuous delivery is performed on the <a href="http://dotty-ci.epfl.ch/lampepfl/dotty">Dotty CI</a> server <sup id="anchor_00"><a href="#footnote_00">[0]</a></sup> from <a href="https://lamp.epfl.ch/">LAMP/EPFL</a>.</br>This document describes changes we made to the <a href="https://github.com/lampepfl/dotty/">lampepfl/dotty</a> repository in order to reproduce the same build/test steps locally on a Windows machine.
  </td>
  </tr>
</table>

This document is part of a series of topics related to [Dotty] on Windows:

- [Running Dotty on Windows](README.md)
- Building Dotty on Windows [**&#9660;**](#bottom)
- [Data Sharing and Dotty on Windows](CDS.md)
- [OpenJDK and Dotty on Windows](OPENJDK.md)

[JMH], [Metaprogramming][dotty_metaprogramming], [GraalSqueak][graalsqueak_examples], [GraalVM][graalvm_examples], [Kotlin][kotlin_examples] and [LLVM][llvm_examples] are other topics we are currently investigating.

## <span id="proj_deps">Project dependencies</span>

Our [Dotty fork][github_dotty_fork] depends on the following external software for the **Microsoft Windows** platform:

- [Git 2.25][git_releases] ([*release notes*][git_relnotes])
- [Oracle OpenJDK 8][openjdk_releases] <sup id="anchor_01">[[1]](#footnote_01)</sup> ([*release notes*][openjdk_relnotes])
- [SBT 1.3][sbt_releases] (requires Java 8) ([*release notes*][sbt_relnotes])
<!--
8u212 -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-April/009115.html
8u222 -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-July/009840.html
8u232 -> https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-October/010452.html
-->
> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [**`/opt/`**][unix_opt] directory on Unix).

For instance our development environment looks as follows (*January 2020*):

<pre style="font-size:80%;">
C:\opt\Git-2.25.0\
C:\opt\jdk-1.8.0_242-b08\
C:\opt\sbt-1.3.7\
</pre>

> **:mag_right:** [Git for Windows][git_win] provides a BASH emulation used to run [**`git`**][git_cli] from the command line (as well as over 250 Unix commands like [**`awk`**][man1_awk], [**`diff`**][man1_diff], [**`file`**][man1_file], [**`grep`**][man1_grep], [**`more`**][man1_more], [**`mv`**][man1_mv], [**`rmdir`**][man1_rmdir], [**`sed`**][man1_sed] and [**`wc`**][man1_wc]).

## Directory structure

The directory structure of the [Dotty repository][github_dotty] <sup id="anchor_02">[[2]](#footnote_02)</sup>  is quite complex but fortunately we only have to deal with the three subdirectories [**`bin\`**](https://github.com/michelou/dotty/tree/master/bin), [**`dist\bin\`**](https://github.com/michelou/dotty/tree/master/dist/bin) and [**`project\scripts\`**](https://github.com/michelou/dotty/tree/master/project/scripts).

<pre style="font-size:80%;">
dotty\      <i>(Git submodule)</i><sup id="anchor_03"><a href="#footnote_03">[3]</a></sup>
dotty\bin\
dotty\dist\bin\
dotty\project\scripts\
</pre>

Concretely directories [**`dotty\bin\`**](https://github.com/michelou/dotty/tree/master/bin), [**`dotty\dist\bin\`**](https://github.com/michelou/dotty/tree/master/dist/bin) and [**`dotty\project\scripts\`**](https://github.com/michelou/dotty/tree/master/project/scripts) are modified with the following additions:

<pre style="font-size:80%;">
dotty\bin\common.bat
dotty\bin\dotc.bat
dotty\bin\dotd.bat
dotty\bin\dotr.bat
dotty\dist\bin\common.bat
dotty\dist\bin\dotc.bat
dotty\dist\bin\dotd.bat
dotty\dist\bin\dotr.bat
dotty\project\scripts\bootstrapCmdTests.bat
dotty\project\scripts\cmdTests.bat
dotty\project\scripts\common.bat
dotty\project\scripts\genDocs.bat
</pre>

We also define a virtual drive **`W:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).

> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; subst V: %USERPROFILE%\workspace\dotty-examples</b>
> </pre>

In the next section we give a brief description of the batch files present in those directories.

## <span id="batch_commands">Batch/Bash commands</span>

We distinguish different sets of batch commands:

1. Directory [**`bin\0.21\`**](bin/0.21) - This directory contains the shell scripts and batch files to be added unchanged to a [Dotty software distribution][dotty_releases].

   <pre style="font-size:80%;">
   <b>&gt; cp bin\0.21\*.bat dotty\dist\bin</b>
   <b>&gt; dir /b dotty\dist\bin</b>
   common
   common.bat
   dotc
   dotc.bat
   dotd
   dotd.bat
   dotr
   dotr.bat
   </pre>

2. [**`build.bat`**](bin/dotty/build.bat)/[**`build.sh`**](bin/dotty/build.sh) - Both commands perform on a Windows machine the same build/test steps as specified in file [**`.drone.yml`**](https://github.com/michelou/dotty/blob/master/.drone.yml) and executed on the [Dotty CI][dotty_ci] server.

   > **:mag_right:** We get the same behavior when working with command [**`./build.sh`**](bin/dotty/build.sh) as presented below with command [**`build.bat`**](bin/dotty/build.bat).

   <pre style="font-size:80%;">
   <b>&gt; cp bin\dotty\build.bat dotty</b>
   <b>&gt; cp bin\dotty\project\scripts\*.bat dotty\project\scripts\</b>
   <b>&gt; cd dotty</b></pre>

   Command [**`build.bat help`**](bin/dotty/build.bat) display the help message.

   <pre style="font-size:80%;">
   <b>&gt; cd</b>
   V:\dotty
   &nbsp;
   <b>&gt; build help</b>
   Usage: build { &lt;option&gt; | &lt;subcommand&gt; }
   &nbsp;
     Options:
       -timer                 display the total build time
       -verbose               display environment settings
   &nbsp;
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
       update                 fetch/merge upstream repository
   &nbsp;
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
    > | `build compile` | `build clone compile-only` |
    > | `build bootstrap` | `build compile bootstrap-only` |
    > | `build archives` | `build bootstrap archives-only` |
    > | `build documentation` | `build bootstrap documentation-only` |
    > | `build sbt` | `build bootstrap sbt-only` |

3. Directory [**`bin\dotty\bin\`**](bin/dotty/bin) - This directory contains batch files used internally during the build process (see the [**`bootstrapCmdTests.bat`**](bin/dotty/project/scripts/bootstrapCmdTests.bat) command).
   <pre style="font-size:80%;">
   <b>&gt; cp bin\dotty\bin\*.bat dotty\bin</b>
   <b>&gt; dir /b dotty\bin</b>
   common
   common.bat
   dotc
   dotc.bat
   dotd
   dotd.bat
   dotr
   dotr.bat
   </pre>

4. [**`bin\dotty\project\scripts\`**](bin/dotty/project/scripts/) - This directory contains bash files to performs test steps on a Windows machine in a similar manner to the shell scripts on the [Dotty CI][dotty_ci] server (see console output in section [**Usage examples**](#usage_examples)).

   | Batch file (**`build.bat`**) | Bash script (**`./build.sh`**) |
   | :--------- | :---------- |
   | [**`cmdTests.bat`**](bin/dotty/project/scripts/cmdTests.bat) | [**`cmdTests`**](https://github.com/michelou/dotty/blob/master/project/scripts/cmdTests) |
   | [**`bootstrapCmdTests.bat`**](bin/dotty/project/scripts/bootstrapCmdTests.bat) | [**`bootstrapCmdTests`**](https://github.com/michelou/dotty/blob/master/project/scripts/bootstrapCmdTests) |
   | [**`genDocs.bat`**](bin/dotty/project/scripts/genDocs.bat) | [**`genDocs`**](https://github.com/michelou/dotty/blob/master/project/scripts/genDocs)|


## <span id="contribs">Contributions</span>

We have come across several issues <sup id="anchor_04"><a href="#footnote_04">[4]</a></sup> while executing [Dotty] commands on Windows:

| [ &nbsp;&nbsp;&nbsp;&nbsp;Issues&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ](https://github.com/lampepfl/dotty/issues?q=is%3Aissue+author%3Amichelou) | &nbsp;&nbsp;Issue status&nbsp;&nbsp;&nbsp; | Context |
| :--------: | :--------: | :--------- |
| [#7720][dotty_issue_7720] | [fixed](https://github.com/lampepfl/dotty/pull/7691) | staging |
| [#7148][dotty_issue_7146] | [fixed](https://github.com/dotty-staging/dotty/commit/2c529c6) | shell scripts |
| [#6868][dotty_issue_6868] | [fixed](https://github.com/lampepfl/dotty/commit/0ea949a) | class file parser |
| [#6367][dotty_issue_6367] | *open* | Dotty REPL |
| [#4356][dotty_issue_4356] | [won't fix](https://github.com/lampepfl/dotty/issues/4356#event-2098905156) | Windows batch command |
| [#4272][dotty_issue_4272] | [fixed](https://github.com/lampepfl/dotty/commit/9723748) | type constraints|

| [Pull request](https://github.com/lampepfl/dotty/pulls?q=is%3Apr+author%3Amichelou) | Request status | Context |
| :--------: | :--------: | :--------- |
| [#6653][dotty_pr_6653] | [merged](https://github.com/lampepfl/dotty/commit/fe02bf4fdc14f648b5f42731e39448995963256c) | Batch commands |
| [#5814](https://github.com/lampepfl/dotty/pull/5814) | [merged](https://github.com/lampepfl/dotty/commit/923fb06dc625e054e8b1833d4b7db49d369d91ad) | **`build compile`** |
| [#5659](https://github.com/lampepfl/dotty/pull/5659) | [merged](https://github.com/lampepfl/dotty/commit/7b9ffbb56b2bd33efead1c0f38a71c057c31463e) | **`build bootstrap`** |
| [#5587](https://github.com/lampepfl/dotty/pull/5587) | [merged](https://github.com/lampepfl/dotty/commit/172d6a0a1a3a4cbdb0a3ac4741b3f561d1221c40) | **`build bootstrap`** |
| [#5561](https://github.com/lampepfl/dotty/pull/5561) | [merged](https://github.com/lampepfl/dotty/commit/24a2798f51e1cc01d476b9c00ac0e4b925acc8e5) | **`build bootstrap`** |
| [#5487](https://github.com/lampepfl/dotty/pull/5487) | [merged](https://github.com/lampepfl/dotty/commit/052c3b1) | **`build bootstrap`** |
| [#5457](https://github.com/lampepfl/dotty/pull/5457) | [merged](https://github.com/lampepfl/dotty/commit/eb175cb) | **`build compile`** |
| [#5452](https://github.com/lampepfl/dotty/pull/5452) | [merged](https://github.com/lampepfl/dotty/commit/7e093b15ff2a927212c7f40aa36b71d0a28f81b5) | Code review |
| [#5444](https://github.com/lampepfl/dotty/pull/5444) | [closed](https://github.com/lampepfl/dotty/pull/5444#issuecomment-567178490) | Batch commands |
| [#5430](https://github.com/lampepfl/dotty/pull/5430) | [merged](https://github.com/lampepfl/dotty/commit/81b30383800495c64f2c8cfd0979e69e504104bc) | **`build documentation`** |

> **&#9755;** Related pull requests from other contributors include:<br/>
> <ul><li><a href="https://github.com/lampepfl/dotty/pull/5560">#5560</a> Fix Windows path (<a href="https://github.com/lampepfl/dotty/commit/67c86783ff48723ae96fedeb51c50db62f375042">merged</a>).</li>
> <li><a href="https://github.com/lampepfl/dotty/pull/5531">#5531</a> Test AppVeyor integration (<a href="https://github.com/lampepfl/dotty/pull/5531#issuecomment-446505630">closed</a>).</li></ul>

Below we summarize changes we made to the [source code](https://github.com/lampepfl/dotty/) of the [Dotty] project:

- Unspecified character encoding in some file operations<br/>*Example*: [**`Source.fromFile(f)`**](https://www.scala-lang.org/api/2.12.7/scala/io/Source$.html) **&rarr;** **`Source.fromFile(f, "UTF-8")`**.
- Platform-specific new lines<br/>*Example*: **`"\n"`** **&rarr;** [**`System.lineSeparator`**](https://docs.oracle.com/javase/8/docs/api/java/lang/System.html#lineSeparator).
- Platform-specific path separators<br/>*Example*: **`":"`** **&rarr;** [**`java.io.File.pathSeparator`**](https://docs.oracle.com/javase/8/docs/api/java/io/File.html#pathSeparator).
- Illegal characters in file names<br/>*Example*: **`new PlainFile(Path("<quote>"))`** **&rarr;** **`new VirtualFile("<quote>")`**
- Transformation of URL addresses to file system paths<br/>*Example*: [**`url.getFile`**](https://docs.oracle.com/javase/8/docs/api/java/net/URL.html#getFile) **&rarr;** **`Paths.get(url.toURI).toString`**.
- Unspecified character encoding when piping stdout<br/>*Example*: **`new InputStreamReader(process.getInputStream)`** **&rarr;** **`new InputStreamReader(process.getInputStream, "UTF-8")`**<br/>where **`process`** has type [**`ProcessBuilder`**](https://docs.oracle.com/javase/8/docs/api/java/lang/ProcessBuilder.html).

## <span id="usage_examples">Usage examples</span>

Command [**`build.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/build.bat) consists of ~400 lines of batch/[Powershell ][microsoft_powershell] code and features the following subcommands:

#### `build.bat cleanall`

Command **`build.bat cleanall`** removes all generated *and untracked* files/directories from our [**Dotty fork**][github_dotty_fork].<br/>Internally, **`build cleanall`** executes the two commands **`sbt clean`** *and* [**`git clean -xdf`**][git_clean] which removes all untracked directories/files, including build products.

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
   GIT_CMD=C:\opt\Git-2.25.0\bin\git.exe
   JAVA_CMD=C:\opt\jdk-1.8.0_242-b08\bin\java.exe
   SBT_CMD=C:\opt\sbt-1.3.7\bin\sbt.bat
Tool options
   JAVA_OPTS=-Xmx2048m -XX:ReservedCodeCacheSize=2048m -XX:MaxMetaspaceSize=1024m
   SBT_OPTS=-Ddotty.drone.mem=4096m -Dsbt.ivy.home=U:\.ivy2\ -Dsbt.log.noformat=true
Current Git branch
   master
&nbsp;
[...(sbt)...]
[...(git)...]
</pre>

#### `build.bat compile`

Command **`build.bat compile`** generates the *"1st stage compiler"* for [Dotty] and executes the relevant test suites. 

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

#### `build.bat bootstrap`

Command **`build.bat bootstrap`** works as follows: ***if*** execution of the **`compile`** subcommand was successful the **`bootstrap`** subcommand generates the *"bootstrap compiler"* for [Dotty] and executes the relevant test suites.

<pre style="font-size:80%;">
<b>&gt; build bootstrap</b>
[...]
</pre>

#### `build.bat community`

Command **`build.bat community`**  generates subprojects from **`community-build\community-projects\`**: 

<pre style="font-size:80%;">
<b>&gt; build community</b>
[...]
</pre>

#### `build.bat archives`

Command **`build.bat archives`** works as follows:  ***if*** execution of the **`bootstrap`** subcommand was successful the **`archives`** subcommand generates the gz/zip archives.<br/>Below we execute the **`arch-only`** subcommand for the sake of brievity (previous steps are *assumed* to be successful): 

<pre style="font-size:80%;">
<b>&gt; build arch-only</b>
[...]
&nbsp;
<b>&gt; dir /a-d /b dist-bootstrapped\target</b>
dotty-0.19.1-bin-SNAPSHOT.tar.gz
dotty-0.19.1-bin-SNAPSHOT.zip
</pre>

#### `build.bat documentation`

Command **`build.bat documentation`** works as follows: ***if*** execution of the **`bootstrap`** subcommand was successful the **`documentation`** subcommand generates the [Dotty website][dotty] and the online [Dotty documentation][dotty_docs].<br/>Below we execute the **`doc-only`** subcommand for the sake of brievity (previous operations are *assumed* to be successful): 

<pre style="font-size:80%;">
<b>&gt; build -timer doc-only</b>
Working directory: W:\dotty
[...]
[info] Running (fork) dotty.tools.dottydoc.Main -siteroot docs -project Dotty -project-version 0.20.0-bin-SNAPSHOT -project-url https://github.com/lampepfl/dotty ...
Compiling (1/406): AlternateConstructorsPhase.scala
[...]
Compiling (406/406): package.scala
[...]
28 warnings found
there were 3987 feature warning(s); re-run with -feature for details
[doc info] Generating doc page for: dotty.tools.dotc.plugins
[...]
[doc info] Generating doc page for: dotty.tools.dotc.core.unpickleScala2.Scala2Unpickler$.TempPolyType$
&equals;================================================================================
Dottydoc summary report for project `Dotty`
&equals;================================================================================
Documented members in public API:
[...]
Summary:
&nbsp;
public members with docstrings:    5181/14606 (35%)
protected members with docstrings: 164/537 (30%)
&equals;================================================================================
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

Output directory **`docs\_site\`** contains the files of the online [Dotty documentation][dotty_docs]:

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

Output directory **`docs\docs\`** contains the Markdown files of the [Dotty website][dotty]:

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

#### `cmdTests.bat`

Command [**`project\scripts\cmdTests.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/cmdTests.bat) performs several tests running [Dotty](https://dotty.epfl.ch) commands from [**`sbt`**][sbt_cli]. In the normal case, command [**`cmdTests`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/cmdTests.bat) is called by command **`build compile`** but may also be called directly.

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

#### `bootstrapCmdTests.bat`

Command [**`project\scripts\bootstrapCmdTests.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/bootstrapCmdTests.bat) performs several benchmarks and generates the documentation page for the [**`tests\pos\HelloWorld.scala`**](https://github.com/michelou/dotty/tree/master/tests/pos/HelloWorld.scala) program. In the normal case, command [**`bootstrapCmdTests`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/bootstrapCmdTests.bat) is called by command **`build bootstrap`** but may also be called directly.

<pre style="font-size:80%;">
<b>&gt; bootstrapCmdTests</b>
[...]
[info] Updating dotty-bench...
[...]
[info] Running (fork) dotty.tools.benchmarks.Bench 1 1 tests/pos/alias.scala
# JMH version: 1.22
# VM version: JDK 1.8.0_242, VM 25.242-b08
# VM invoker: C:\opt\jdk-1.8.0_242-b08\bin\java.exe
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
# JMH version: 1.22
# VM version: JDK 1.8.0_242, VM 25.242-b08
# VM invoker: C:\opt\jdk-1.8.0_242-b08\bin\java.exe
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
# JMH version: 1.22
# VM version: JDK 1.8.0_242, VM 25.242-b08
# VM invoker: C:\opt\jdk-1.8.0_242-b08\bin\java.exe
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

#### `genDocs.bat`

Command [**`genDocs.bat`**](https://github.com/michelou/dotty/tree/batch-files/project/scripts/genDocs.bat) generates the documentation page for program [**`tests\pos\HelloWorld.scala`**](https://github.com/michelou/dotty/tree/master/tests/pos/HelloWorld.scala).

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

## <span id="footnotes">Footnotes</span>

<a name="footnote_00">[0]</a> ***Continuous Integration/Delivery*** (CI/CD) [↩](#anchor_00)

<p style="margin:0 0 1em 20px;">
Steps are: Checkout <b>&rarr;</b> Compile <b>&rarr;</b> Test <b>&rarr;</b> Deploy.
</p>
<table style="margin:0 0 1em 20px;">
<tr><th>Software</th<th>CI/CD&nbsp;service</th<th>Hosting</th></tr>
<tr><td><a href="http://dotty-ci.epfl.ch/lampepfl/dotty">Dotty</a></td><td>[Drone](https://drone.io/) <sup>**(1)**</sup></td><td>[EPFL][dotty_ci] in Lausanne, Switzerland</td></tr>
<tr><td>[Scala](https://www.scala-lang.org/)</td><td>[Jenkins](https://jenkins.io/doc/) <sup>**(2)**</sup><br/>[Travis CI](https://docs.travis-ci.com/user/tutorial/) <sup>**(3)**</sup></td><td>[Lightbend ](https://scala-ci.typesafe.com/) in San-Francisco, USA<br/>[Travis](https://travis-ci.org/scala/scala) in Berlin, Germany</td></tr>
<tr><td>[Oracle&nbsp;OpenJDK](https://ci.adoptopenjdk.net/)</td><td>[Jenkins](https://jenkins.io/doc/) <sup>**(2)**</sup></td><td>Oracle</td></tr>
<tr><td><a href="https://ci.eclipse.org/openj9/">IBM OpenJ9</a></td><td><a href="https://jenkins.io/doc/">Jenkins</a> <sup><b>(2)</b></sup></td><td>IBM</td></tr>
</table>
<div style="margin:0 0 1em 20px;">
<sub><sup><b>(1)</b></sup> Written in [Go](https://github.com/drone/drone), <sup><b>(2)</b></sup> Written in [Java][java_lang], <sup><b>(3)</b></sup> Written in [Ruby][ruby_lang].</sub>
</div>

<a name="footnote_01">[1]</a> ***Java LTS** (2018-11-18)* [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
Oracle annonces in his <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">Java SE Support Roadmap</a> he will stop public updates of Java SE 8 for commercial use after January 2019. Launched in March 2014 Java SE 8 is classified an <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">LTS</a> release in the new time-based system and <a href="https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html">Java SE 11</a>, released in September 2018, is the current LTS release.<br/>(see also <a href="https://www.slideshare.net/HendrikEbbers/java-11-omg">Java 11 keynote</a> from <a href="https://www.jvm-con.de/speakers/#/speaker/3461-hendrik-ebbers">Hendrik Ebbers</a> at <a href="https://www.jvm-con.de/ruckblick/">JVM-Con 2018</a>).
</p>

<a name="footnote_02">[2]</a> ***Git master repository*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
Nowadays we have experienced two times the error <code>Server does not allow request for unadvertised object..</code> when synchronizing our fork with the <a href="https://github.com/lampepfl/dotty"><b><code>lampepfl/dotty</code></b></a> repository:
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; git fetch upstream master</b>
<b>&gt; git merge upstream/master</b>
[...]
Error: Server does not allow request for unadvertised object ...
</pre>
<p style="margin:0 0 1em 20px;">
That error is caused by one of the subprojects in directory <b><code>community-build\community-projects\</code></b> and can be solved with the following commands:
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; git submodule sync</b>
<b>&gt; git submodule update --depth 50</b>
</pre>

<a name="footnote_03">[3]</a> ***Git submodule*** [↩](#anchor_03)

<p style="margin:0 0 1em 20px;">
Defining directory <b><code>dotty\</code></b> as a Github submodule allows us to make changes to this project independently from our fork of the <a href="https://github.com/lampepfl/dotty">lampepfl/dotty</a> repository. 
</p>

<a name="footnote_04">[4]</a> ***Git configuration*** [↩](#anchor_04)

<p style="margin:0 0 1em 20px;">
We report here one issue we encountered when working with the <a href="https://git-scm.com/docs/git-config"><b><code>git</code></b></a> command on Windows, namely the error message <code>"Filename too long"</code>:
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; git status</b>
mainExamples/src/main/scala/examples/main/active/writing/toConsoleWriting/info/reading/argumentAndResultMultiplier/FactorialOfArgumentMultipliedByResultMultiplierMain.scala: Filename too long
   On branch batch-files
   Your branch is ahead of 'origin/batch-files' by 1106 commits.
      (use "git push" to publish your local commits)
</pre>
<p style="margin:0 0 1em 20px;">
We fixed our local Git settings as follows:
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; git config --system core.longpaths true</b>
</pre>
</p>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/January 2020* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[dotty]: https://dotty.epfl.ch/
[dotty_ci]: http://dotty-ci.epfl.ch/lampepfl/dotty
[dotty_issue_4272]: https://github.com/lampepfl/dotty/issues/4272
[dotty_issue_4356]: https://github.com/lampepfl/dotty/issues/4356
[dotty_issue_6367]: https://github.com/lampepfl/dotty/issues/6367
[dotty_issue_6868]: https://github.com/lampepfl/dotty/issues/6868
[dotty_issue_7146]: https://github.com/lampepfl/dotty/issues/7146
[dotty_issue_7720]: https://github.com/lampepfl/dotty/issues/7720
[dotty_docs]: https://dotty.epfl.ch/docs/
[dotty_metaprogramming]: http://dotty.epfl.ch/docs/reference/metaprogramming/toc.html
[dotty_pr_6653]: https://github.com/lampepfl/dotty/pull/6653
[dotty_releases]: https://github.com/lampepfl/dotty/releases
[git_clean]: https://git-scm.com/docs/git-clean/
[git_cli]: https://git-scm.com/docs/git
[git_releases]: https://git-scm.com/download/win
[git_relnotes]: https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.25.0.txt
[git_win]: https://git-scm.com/
[github_dotty]: https://github.com/lampepfl/dotty/
[github_dotty_fork]: https://github.com/michelou/dotty/tree/master/
[graalsqueak_examples]: https://github.com/michelou/graalsqueak-examples
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[java_lang]: https://www.oracle.com/technetwork/java/index.html
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
[microsoft_powershell]: https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6
[openjdk_releases]: https://adoptopenjdk.net/?variant=openjdk8&jvmVariant=hotspot
[openjdk_relnotes]: https://mail.openjdk.java.net/pipermail/jdk8u-dev/2019-October/010452.html
[ruby_lang]: https://www.ruby-lang.org/en/
[sbt_cli]: https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html
[sbt_releases]: https://www.scala-sbt.org/download.html
[sbt_relnotes]: https://github.com/sbt/sbt/releases/tag/v1.3.7
[unix_opt]: http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
