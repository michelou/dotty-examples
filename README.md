# <span id="top">Running Dotty on Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="docs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This repository gathers code examples coming from various websites - mostly from the <a href="http://dotty.epfl.ch/">Dotty project</a> - or written by myself.<br/>
    In particular it includes several <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a> for experimenting with the Dotty language (aka <a href="https://www.scala-lang.org/blog/2018/04/19/scala-3.html">Scala 3</a>) on a Windows machine.
  </td>
  </tr>
</table>

This page is part of a series of topics related to [Dotty](http://dotty.epfl.ch/) on Windows:

- Running Dotty on Windows [**&#9660;**](#bottom)
- [Building Dotty on Windows](DRONE.md)
- [Data Sharing and Dotty on Windows](CDS.md)
- [OpenJDK and Dotty on Windows](OPENJDK.md)

Other topics we are currently investigating include [JMH](https://openjdk.java.net/projects/code-tools/jmh/), [OpenJDK 11](https://adoptopenjdk.net/) and [Tasty](https://www.scala-lang.org/blog/2018/04/30/in-a-nutshell.html).

## <span id="section_01">Project dependencies</span>

This project depends on two external software for the **Microsoft Windows** platform:

- [Oracle OpenJDK 8](https://adoptopenjdk.net/?variant=openjdk8&jvmVariant=hotspot)<sup id="anchor_01">[[1]](#footnote_01)</sup> ([*release notes*](https://wiki.openjdk.java.net/display/jdk8u/JDK+8u202))
- [Dotty 0.12](https://github.com/lampepfl/dotty/releases) (Java 9+ supported since 0.10) 

Optionally you may also install the following software:

- [Scala 2.12](https://www.scala-lang.org/download/) (requires Java 8) ([*release notes*](https://github.com/scala/scala/releases/tag/v2.12.8))
- [SBT 1.2.8](https://www.scala-sbt.org/download.html) (requires Java 8) ([*release notes*](https://github.com/sbt/sbt/releases/tag/v1.2.8))
- [Apache Ant 1.10](https://ant.apache.org/) (requires Java 8) ([*release notes*](https://archive.apache.org/dist/ant/RELEASE-NOTES-1.10.5.html))
- [Gradle 5.2](https://gradle.org/install/) ([requires Java 8 or newer](https://docs.gradle.org/current/release-notes.html#potential-breaking-changes)) ([*release notes*](https://docs.gradle.org/5.2.1/release-notes.html))
- [Apache Maven 3.6](http://maven.apache.org/download.cgi) ([requires Java 7](http://maven.apache.org/docs/history.html))  ([*release notes*](http://maven.apache.org/docs/3.6.0/release-notes.html))
- [Mill 0.3](https://www.lihaoyi.com/mill/) ([*change log*](https://github.com/lihaoyi/mill#changelog))
- [CFR 0.13](http://www.benf.org/other/cfr/) (Java decompiler)
- [Git 2.20](https://git-scm.com/download/win) ([*release notes*](https://raw.githubusercontent.com/git/git/master/Documentation/RelNotes/2.20.1.txt))

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive](https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/) rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`](http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) directory on Unix).

For instance our development environment looks as follows (*February 2019*):

<pre style="font-size:80%;">
C:\opt\jdk-1.8.0_202-b081\
C:\opt\apache-ant-1.10.5\
C:\opt\apache-maven-3.6.0\
C:\opt\cfr-0.139\
C:\opt\dotty-0.12.0-RC1\
C:\opt\Git-2.20.1\
C:\opt\gradle-5.2.1\
C:\opt\Mill-0.3.6\
C:\opt\sbt-1.2.8\
C:\opt\scala-2.12.8\
</pre>

> **:mag_right:** Git for Windows provides a BASH emulation used to run [**`git`**](https://git-scm.com/docs/git) from the command line (as well as over 250 Unix commands like [**`awk`**](https://www.linux.org/docs/man1/awk.html), [**`diff`**](https://www.linux.org/docs/man1/diff.html), [**`file`**](https://www.linux.org/docs/man1/file.html), [**`grep`**](https://www.linux.org/docs/man1/grep.html), [**`more`**](https://www.linux.org/docs/man1/more.html), [**`mv`**](https://www.linux.org/docs/man1/mv.html), [**`rmdir`**](https://www.linux.org/docs/man1/rmdir.html), [**`sed`**](https://www.linux.org/docs/man1/sed.html) and [**`wc`**](https://www.linux.org/docs/man1/wc.html)).

We further recommand using an advanced console emulator such as [ComEmu](https://conemu.github.io/) (or [Cmdr](http://cmder.net/)) which features [Unicode support](https://conemu.github.io/en/UnicodeSupport.html).

## Directory structure

This project is organized as follows:
<pre style="font-size:80%;">
bin\*.bat
bin\0.12\*.bat
bin\cfr-0.139.zip
docs\
examples\{dotty-example-project, ..}
myexamples\{00_AutoParamTupling, ..}
README.md
setenv.bat
</pre>

where

- directory [**`bin\`**](bin/) provides several utility batch commands.
- directory [**`bin\0.12\`**](bin/0.12/) contains the batch commands for Dotty 0.12.
- file [**`bin\cfr-0.139.zip`**](bin/cfr-0.139.zip) contains a zipped distribution of [CFR](http://www.benf.org/other/cfr/).
- directory [**`docs\`**](docs/) contains several Dotty related papers/articles.
- directory [**`examples\`**](examples/) contains Dotty examples grabbed from various websites.
- directory [**`myexamples\`**](myexamples/) contains self-written Dotty examples.
- file [**`README.md`**](README.md) is the [Markdown](https://github.github.com/gfm/) document for this page.
- file [**`setenv.bat`**](setenv.bat) is the batch command for setting up our environment.

> **:mag_right:** We use the portable version of [MarkdownPad 2](http://markdownpad.com/faq.html#portable) to edit our Markdown files (see article ["Mastering Markdown"](https://guides.github.com/features/mastering-markdown/) from [GitHub Guides](https://guides.github.com/)).

We also define a virtual drive **`W:`** in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"](https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation) from Microsoft Support).
> **:mag_right:** We use the Windows external command [**`subst`**](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst) to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; subst W: %USERPROFILE%\workspace</b>
> </pre>

In the next section we give a brief description of the batch files present in this repository.

## Batch commands

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](setenv.bat) - This batch command makes external tools such as [**`javac.exe`**](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.html), [**`scalac.bat`**](https://docs.scala-lang.org/overviews/compiler-options/index.html), [**`dotc.bat`**](bin/0.12/dotc.bat), etc. directly available from the command prompt (see section [**Project dependencies**](#section_01)).

    <pre style="font-size:80%;">
    <b>&gt; setenv help</b>
    Usage: setenv { options | subcommands }
      Options:
        -verbose         display environment settings
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

3. Directory [**`bin\0.12\`**](bin/0.12/) - This directory contains batch files to be copied to the **`bin\`** directory of the Dotty installation (eg. **`C:\opt\dotty-0.12.0-RC1\bin\`**) in order to use the [**`dotc`**](bin/0.12/dotc.bat), [**`dotd`**](bin/0.12/dotd.bat) and [**`dotr`**](bin/0.12/dotr.bat) commands on **Microsoft Windows**.
    > **&#9755;** We wrote (and do maintain) those batch files based on the bash scripts available from the official [Dotty distribution](https://github.com/lampepfl/dotty/releases). We also have submitted pull request [#5444](https://github.com/lampepfl/dotty/pull/5444) to add them to the Scala distribution.

    <pre style="font-size:80%;">
    <b>&gt; dir /b c:\opt\dotty-0.12.0-RC1\bin</b>
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

4. [**`build.bat`**](examples/dotty-example-project/build.bat) - Finally each example can be built/run using the **`build`** command.<br/>
    > **&#9755;** We prefer command **`build`** here since our code examples are simple and don't require the [**`sbt`** ](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html)machinery (eg. [library dependencies](https://www.scala-sbt.org/1.x/docs/Library-Dependencies.html), [sbt server](https://www.scala-sbt.org/1.x/docs/sbt-server.html)).

    <pre style="font-size:80%;">
    <b>&gt; build</b>
    Usage: build { options | subcommands }
      Options:
        -debug           show commands executed by this script
        -explain         set compiler option -explain
        -explain-types   set compiler option -explain-types
        -compiler:&lt;name&gt; select compiler (scala|scalac|dotc|dotty), default:dotc
        -main:&lt;name&gt;     define main class name
        -tasty           compile both from source and TASTy files
        -timer           display the compile time
        -verbose         display progress messages
      Subcommands:
        clean            delete generated class files
        compile          compile source files (Java and Scala)
        doc              generate documentation
        help             display this help message
        run              execute main class
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
    | [**`sbt`**](https://www.scala-sbt.org/) | [**`build.sbt`**](examples/enum-Planet/build.sbt) | &empty; | **`sbt clean compile run`** |
    | [**`ant`**](https://ant.apache.org/manual/running.html) | [**`build.xml`**](examples/enum-Planet/build.xml) | [**`build.xml`**](examples/build.xml) | **`ant clean compile run`** |
    | [**`gradle`**](https://docs.gradle.org/current/userguide/command_line_interface.html) | [**`build.gradle`**](examples/enum-Planet/build.gradle) | [**`common.gradle`**](examples/common.gradle) | **`gradle clean build run`** |
    | [**`mill`**](http://www.lihaoyi.com/mill/#command-line-tools) | [**`build.sc`**](examples/enum-Planet/build.sc) | &empty; | **`mill -i go`** |
    | [**`mvn`**](http://maven.apache.org/ref/3.6.0/maven-embedder/cli.html) | [**`pom.xml`**](examples/enum-Planet/pom.xml) | [**`pom.xml`**](examples/pom.xml) | **`mvn clean compile test`** |

2. Decompiler tools

    As an alternative to the standard [**`javap`**](https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javap.html) class decompiler one may use **`cfr.bat`** (simply extract [**`bin\cfr-0.139.zip`**](bin/cfr-0.139.zip) to **`c:\opt\`**) which prints [Java source code](https://docs.oracle.com/javase/specs/jls/se8/html/index.html) instead of [Java bytecode](https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-6.html):

    <pre style="font-size:80%;">
    <b>&gt; cfr myexamples\00_AutoParamTupling\target\classes\Main.class</b>
    /*
     * Decompiled with CFR 0.139.
     */
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
    <b>&gt; javap -c myexamples\00_AutoParamTupling\target\classes\Main.class</b>
    Compiled from "Main.scala"
    public final class Main {
      public static void test01();
        Code:
           0: getstatic     #13                 // Field Main$.MODULE$:LMain$;
           3: invokevirtual #15                 // Method Main$.test01:()V
           6: return
    
      public static void main(java.lang.String[]);
        Code:
           0: getstatic     #13                 // Field Main$.MODULE$:LMain$;
           3: aload_0
           4: invokevirtual #19                 // Method Main$.main:([Ljava/lang/String;)V
           7: return
    
      public static void test02();
        Code:
           0: getstatic     #13                 // Field Main$.MODULE$:LMain$;
           3: invokevirtual #22                 // Method Main$.test02:()V
           6: return
    }
    </pre>

## Usage examples

#### `setenv.bat`

Command [**`setenv`**](setenv.bat) is executed once to setup our development environment; it makes external tools such as [**`javac.exe`**](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javac.html), [**`sbt.bat`**](https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html) and [**`git.exe`**](https://git-scm.com/docs/git) directly available from the command prompt:

<pre style="font-size:80%;">
<b>&gt; setenv</b>
Tool versions:
   javac 1.8.0_202, java 1.8.0_202, scalac 2.12.8, dotc 0.12.0-RC1,
   ant 1.10.5, gradle 5.2.1, mill 0.3.6, mvn 3.6.0, sbt 1.2.8/2.12.8,
   cfr 0.139, git 2.20.1.windows.1, diff 3.6

<b>&gt; where sbt</b>
C:\opt\sbt-1.2.8\bin\sbt
C:\opt\sbt-1.2.8\bin\sbt.bat
</pre>

Command [**`setenv -verbose`**](setenv.bat) also displays the tool paths:

<pre style="font-size:80%;">
<b>&gt; setenv -verbose</b>
Tool versions:
   javac 1.8.0_202, java 1.8.0_202, scalac 2.12.8, dotc 0.12.0-RC1,
   ant 1.10.5, gradle 5.2.1, mill 0.3.6, mvn 3.6.0, sbt 1.2.8/2.12.8,
   cfr 0.139, git 2.20.1.windows.1, diff 3.6
Tool paths:
   C:\opt\jdk-1.8.0_202-b08\bin\javac.exe
   C:\opt\jdk-1.8.0_202-b08\bin\java.exe
   C:\ProgramData\Oracle\Java\javapath\java.exe
   C:\Program Files (x86)\Common Files\Oracle\Java\javapath\java.exe
   C:\opt\scala-2.12.8\bin\scalac.bat
   C:\opt\dotty-0.12.0-RC1\bin\dotc.bat
   C:\opt\apache-ant-1.10.5\bin\ant.bat
   C:\opt\gradle-5.2.1\bin\gradle.bat
   C:\opt\Mill-0.3.6\mill.bat
   C:\opt\apache-maven-3.6.0\bin\mvn.cmd
   C:\opt\sbt-1.2.8\bin\sbt.bat
   C:\opt\cfr-0.139\bin\cfr.bat
   C:\opt\Git-2.20.1\bin\git.exe
   C:\opt\Git-2.20.1\usr\bin\diff.exe
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
<b>&gt; dirsize examples myexamples c:\opt\dotty-0.12.0-RC1</b>
Size of directory "examples" is 3.9 Mb
Size of directory "myexamples" is 1.2 Mb
Size of directory "c:\opt\dotty-0.12.0-RC1" is 22.4 Mb
</pre>

#### `getnightly.bat`

By default command [**`getnightly`**](bin/getnightly.bat) downloads the library files of the latest Dotty nightly build available from the [Maven Central Repository](https://search.maven.org/search?q=g:ch.epfl.lamp) and saves them into directory **`out\nightly-jars\`**.

<pre style="font-size:80%;">
<b>&gt; getnightly</b>

<b>&gt; dir /b out\nightly-jars</b>
dotty-compiler_0.13-0.13.0-bin-20190202-03887b7-NIGHTLY.jar
dotty-doc_0.13-0.13.0-bin-20190202-03887b7-NIGHTLY.jar
dotty-language-server_0.13-0.13.0-bin-20190202-03887b7-NIGHTLY.jar
dotty-library_0.13-0.13.0-bin-20190202-03887b7-NIGHTLY.jar
dotty-sbt-bridge-0.13.0-bin-20190202-03887b7-NIGHTLY.jar
dotty_0.13-0.13.0-bin-20190202-03887b7-NIGHTLY.jar
</pre>

Command [**`getnightly -verbose`**](bin/getnightly.bat) also displays the download progress:

<pre style="font-size:80%">
<b>&gt; getnightly -verbose</b>
Downloading file dotty-compiler_0.13-0.13.0-bin-20190202-03887b7-NIGHTLY.jar ... 10.7 Mb
Downloading file dotty-language-server_0.13-0.13.0-bin-20190202-03887b7-NIGHTLY.jar ... 142.7 Kb
Downloading file dotty-doc_0.13-0.13.0-bin-20190202-03887b7-NIGHTLY.jar ... 1013 Kb
Downloading file dotty_0.13-0.13.0-bin-20190202-03887b7-NIGHTLY.jar ... 0.3 Kb
Downloading file dotty-library_0.13-0.13.0-bin-20190202-03887b7-NIGHTLY.jar ... 803.1 Kb
Downloading file dotty-sbt-bridge-0.13.0-bin-20190202-03887b7-NIGHTLY.jar ... 13.3 Kb
Finished to download 6 files to directory W:\DOTTY-~1\out\nightly-jars
</pre>

We can now replace the library files from the original [Dotty distribution](https://github.com/lampepfl/dotty/releases) (installed in directory **`C:\opt\dotty-0.12.0-RC1\`** in our case) with library files from the latest nightly build.

Concretely, we specify the **`activate`** subcommand to switch to the nightly build version and the **`reset`** subcommand to restore the original library files in the Dotty installation directory.

<pre style="font-size:80%;">
<b>&gt; getnightly activate</b>
Finished to download 6 files to directory W:\DOTTY-~1\out\nightly-jars
Activate nightly build libraries: 0.13.0-bin-20190120-e873908-NIGHTLY

<b>&gt; dotc -version</b>
Dotty compiler version 0.13.0-bin-20190120-e873908-NIGHTLY-git-e873908 -- Copyright 2002-2019, LAMP/EPFL

<b>&gt; getnightly reset</b>
Activate default Dotty libraries: 0.12.0-RC1

<b>&gt; dotc -version</b>
Dotty compiler version 0.12.0-RC1 -- Copyright 2002-2018, LAMP/EPFL
</pre>

> **:warning:** You need *write access* to the Dotty installation directory (e.g. **`C:\opt\dotty-0.12.0-RC1\`** in our case) in order to run the **`activate/reset`** subcommands.

Internally command [**`getnightly`**](bin/getnightly.bat) manages two sets of libraries files which are organized as follows:

<pre style="font-size:80%;">
<b>&gt; pushd c:\opt\dotty-0.12.0-RC1&dir/b/a-d&for /f %i in ('dir/s/b/ad lib') do @(echo lib\%~nxi\&dir/b %i)&popd</b>
VERSION
VERSION-NIGHTLY
lib\0.12.0-RC1\
&nbsp;&nbsp;dist_0.12-0.12.0-RC1.jar
&nbsp;&nbsp;dotty-compiler_0.12-0.12.0-RC1.jar
&nbsp;&nbsp;dotty-doc_0.12-0.12.0-RC1.jar
&nbsp;&nbsp;dotty-interfaces-0.12.0-RC1.jar
&nbsp;&nbsp;dotty-library_0.12-0.12.0-RC1.jar
lib\0.13.0-bin-20190120-e873908-NIGHTLY\
&nbsp;&nbsp;dotty-compiler_0.13-0.13.0-bin-20190120-e873908-NIGHTLY.jar
&nbsp;&nbsp;dotty-doc_0.13-0.13.0-bin-20190120-e873908-NIGHTLY.jar
&nbsp;&nbsp;dotty-interfaces-0.13.0-bin-20190120-e873908-NIGHTLY.jar
&nbsp;&nbsp;dotty-language-server_0.13-0.13.0-bin-20190120-e873908-NIGHTLY.jar
&nbsp;&nbsp;dotty-library_0.13-0.13.0-bin-20190120-e873908-NIGHTLY.jar
&nbsp;&nbsp;dotty_0.13-0.13.0-bin-20190120-e873908-NIGHTLY.jar
</pre>

In the above output file **`VERSION-NIGHTLY`** contains the signature of the managed nightly build and the **`lib\`** directory contains two backup directories with copies of the library files from the original Dotty installation respectively from the latest nightly build.

#### `searchjars.bat <class_name>`

Command **`searchjars`** helps us to search for class file names in the following directories: project's **`lib\`** directory (*if present*), Dotty's **`lib\`** directory, Java's **`lib\`** directory and Ivy/Maven default directories.

<pre style="font-size:80%;">
<b>&gt; searchjars -help</b>
Usage: searchjars { options | subcommands }
  Options:
    -artifact        include ~\.ivy2 and ~\.m2 directories
    -help            display this help message
    -ivy             include ~\.ivy directory
    -maven           include ~\.m2 directory
    -verbose         display download progress
  Arguments:
    &lt;class_name&gt;     class name
</pre>

Passing argument **`System`** to command [**`searchjars`**](bin/searchjars.bat) prints the following output (class file names are printed with full path and are prefixed with their containing [JAR file](https://docs.oracle.com/javase/8/docs/technotes/guides/jar/jarGuide.html)):

<pre style="font-size:80%;">
<b>&gt; searchjars System</b>
Searching for class System in library files C:\opt\DOTTY-~1.0-R\lib\*.jar
  scala-library-2.12.8.jar:scala/sys/SystemProperties$.class
  scala-library-2.12.8.jar:scala/sys/SystemProperties.class
  scala-xml_2.12-1.1.0.jar:scala/xml/dtd/SystemID$.class
  scala-xml_2.12-1.1.0.jar:scala/xml/dtd/SystemID.class
Searching for class System in library files C:\opt\SCALA-~1.8\lib\*.jar
  scala-library.jar:scala/sys/SystemProperties$.class
  scala-library.jar:scala/sys/SystemProperties.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID$.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID.class
Searching for class System in library files C:\opt\JDK-8~1.0_2\lib\*.jar
  sa-jdi.jar:sun/jvm/hotspot/memory/SystemDictionary$1.class
  sa-jdi.jar:sun/jvm/hotspot/memory/SystemDictionary$2.class
  sa-jdi.jar:sun/jvm/hotspot/memory/SystemDictionary$ClassAndLoaderVisitor.class
  sa-jdi.jar:sun/jvm/hotspot/memory/SystemDictionary$ClassVisitor.class
  sa-jdi.jar:sun/jvm/hotspot/memory/SystemDictionary.class
  sa-jdi.jar:sun/jvm/hotspot/utilities/SystemDictionaryHelper$1.class
  sa-jdi.jar:sun/jvm/hotspot/utilities/SystemDictionaryHelper$2.class
  sa-jdi.jar:sun/jvm/hotspot/utilities/SystemDictionaryHelper$3.class
  sa-jdi.jar:sun/jvm/hotspot/utilities/SystemDictionaryHelper.class
</pre>

Searching for an unknown class - e.g. **`BinarySearch`** - produces the following output:

<pre style="font-size:80%;">
<b>&gt; searchjars BinarySearch</b>
Searching for class BinarySearch in library files C:\opt\DOTTY-~1.0-R\lib\*.jar
Searching for class BinarySearch in library files C:\opt\SCALA-~1.8\lib\*.jar
Searching for class BinarySearch in library files C:\opt\JDK-8~1.0_2\lib\*.jar
</pre>

Searching for **`FileSystem`** with option **`-artifact`** produces the following output:

<pre style="font-size:80%;">
<b>&gt; searchjars FileSystem -artifact</b>
Searching for class FileSystem in library files C:\opt\DOTTY-~1.0-R\lib\*.jar
Searching for class FileSystem in library files C:\opt\SCALA-~1.8\lib\*.jar
Searching for class FileSystem in library files C:\opt\JDK-8~1.0_2\lib\*.jar
Searching for class FileSystem in library files %USERFPROFILE%\.ivy2\cache\*.jar
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
| `build.sbt` | `dottyVersion` | `0.11.0-RC1` &rarr; `0.12.0-RC1`|
| `project\build.properties` | `sbt.version` | `1.2.7` &rarr; `1.2.8` |
| `project\plugins.sbt` | `sbt-dotty` | `0.2.4` &rarr; `0.2.6` |

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

Command [**`build`**](examples/enum-Planet/build.bat) is a basic build tool consisting of ~400 lines of batch/[Powershell ](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) code <sup id="anchor_02">[[2]](#footnote_02)</sup>. 

Running command [**`build`**](examples/enum-Planet/build.bat) with ***no*** option in project [**`examples\enum-Planet`**](examples/enum-Planet/) generates the following output:

<pre style="font-size:80%;">
<b>&gt; build clean compile run</b>
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406</pre>

More usage examples are presented in [**`examples\README.md`**](examples/README.md) resp. [**`myexamples\README.md`**](myexamples/README.md)


#### `dotr.bat`

[Dotty REPL](https://docs.scala-lang.org/overviews/repl/overview.html) is an interactive tool for evaluating Scala expressions. Internally, it executes a source script by wrapping it in a template and then compiling and executing the resulting program.

   > **:warning:** Batch file [**`dotr.bat`**](bin/0.12/dotr.bat) is based on the bash script [**`dotr`**](https://github.com/lampepfl/dotty/blob/master/dist/bin/dotr) available from the standard [Dotty distribution](https://github.com/lampepfl/dotty/releases). We also have submitted pull request [#5444](https://github.com/lampepfl/dotty/pull/5444) to add that batch file to the Scala distribution.

<pre style="font-size:80%;">
<b>&gt; where dotr</b>
C:\opt\dotty-0.12.0-RC1\bin\dotr
C:\opt\dotty-0.12.0-RC1\bin\dotr.bat

<b>&gt; dotr -version</b>
openjdk version "1.8.0_202"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_202-b08)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.202-b08, mixed mode)

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
val res0: String = C:\opt\jdk-1.8.0_202-b08

<b>scala&gt;</b> System.getenv().get("DOTTY_HOME")
val res1: String = C:\opt\dotty-0.12.0-RC1

<b>scala&gt;</b> :load myexamples/HelloWorld/src/main/scala/HelloWorld.scala
// defined object HelloWorld

<b>scala&gt;</b> HelloWorld.main(Array())
Hello world!

<b>scala&gt;</b>:quit
</pre>

## Footnotes

<!-- ## removed on 2018-11-23 ##
<a name="footnote_01">[1]</a> ***2018-07-07*** [↩](#anchor_02)

<div style="margin:0 0 0 20px;">
Version 0.9 of the Dotty compiler is not compatible with versions 9 and 10 of <a href="https://docs.oracle.com/javase/9/install/overview-jdk-9-and-jre-9-installation.htm">Java JRE</a>; a <strong><code>java.lang.IncompatibleClassChangeError</code></strong> exception is thrown when starting the <strong><code>dotc</code></strong> command:
</div>
-->

<!--
C:\opt\jdk-11.0.1\bin\java.exe -Xmx768m -Xms768m -classpath C:\opt\dotty-0.9.0\lib\scala-library-2.12.6.jar;C:\opt\dotty-0.9.0\lib\scala-xml_2.12-1.1.0.jar;C:\opt\dotty-0.9.0\lib\scala-asm-6.0.0-scala-1.jar;C:\opt\dotty-0.9.0\lib\compiler-interface-1.1.6.jar;C:\opt\dotty-0.9.0\lib\dotty-interfaces-0.9.0.jar;C:\opt\dotty-0.9.0\lib\dotty-library_0.9-0.9.0.jar;C:\opt\dotty-0.9.0\lib\dotty-compiler_0.9-0.9.0.jar -Dscala.usejavacp=true dotty.tools.dotc.Main

C:\opt\jdk-11.0.1\bin\java.exe -Xmx768m -Xms768m -classpath C:\opt\dotty-0.12.0-RC1\lib\scala-library-2.12.8.jar;C:\opt\dotty-0.12.0-RC1\lib\scala-xml_2.12-1.1.0.jar;C:\opt\dotty-0.12.0-RC1\lib\scala-asm-6.0.0-scala-1.jar;C:\opt\dotty-0.12.0-RC1\lib\compiler-interface-1.2.2.jar;C:\opt\dotty-0.12.0-RC1\lib\dotty-interfaces-0.12.0-RC1.jar;C:\opt\dotty-0.12.0-RC1\lib\dotty-library_0.11-0.12.0-RC1.jar;C:\opt\dotty-0.12.0-RC1\lib\dotty-compiler_0.11-0.12.0-RC1.jar -Dscala.usejavacp=true dotty.tools.dotc.Main
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

<a name="footnote_01">[1]</a> ***2018-11-18*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
Oracle annonces in his <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">Java SE Support Roadmap</a> he will stop public updates of Java SE 8 for commercial use after January 2019. Launched in March 2014 Java SE 8 is classified an <a href="https://www.oracle.com/technetwork/java/java-se-support-roadmap.html">LTS</a> release in the new time-based system and <a href="https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html">Java SE 11</a>, released in September 2018, is the current LTS release.
</p>

<a name="footnote_02">[2]</a> ***2018-05-09*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;"> 
Command Prompt has been around for as long as we can remember, but starting with Windows 10 build 14971, Microsoft is trying to make PowerShell the <a href="https://support.microsoft.com/en-us/help/4027690/windows-powershell-is-replacing-command-prompt">main command shell</a> in the operating system.
</p>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/February 2019* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>