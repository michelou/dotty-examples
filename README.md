# Playing with Dotty

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This repository gathers Dotty examples coming from various websites - mostly from the <a href="http://dotty.epfl.ch/">Dotty project</a> - or written by myself.<br/>
    It also includes several batch scripts for experimenting with Dotty (aka Scala 3.0) on the <b>Microsoft Windows</b> platform.
  </td>
  </tr>
</table>

## Project dependencies

This project repository relies on a few external software for the **Microsoft Windows** plaform:

- [Oracle Java 8 SDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- [Dotty 0.8](https://github.com/lampepfl/dotty/releases) (requires Java 8 <sup id="anchor_01">[[1]](#footnote_01)</sup>)
- [SBT 1.x](https://www.scala-sbt.org/download.html)

Optionally one may also install the following software:

- [Scala 2.12](https://www.scala-lang.org/download/) (requires Java 8)
- [Apache Ant 1.10](https://ant.apache.org/) (requires Java 8)
- [Gradle 4.7](https://gradle.org/install/) (requires Java 7 or newer)
- [Apache Maven 3.5](http://maven.apache.org/download.cgi)
- [CFR 0.x](http://www.benf.org/other/cfr/) (Java decompiler)
- [Git 2.x](https://git-scm.com/download/win)

> ***Software installation policy***<br/>
> Whenever possible software is installed via a Zip archive rather than via a Windows installer.

For instance our development environment looks as follows (*May 2018*):

<pre style="font-size:80%;">
C:\Program Files\Java\jdk1.8.0_171\
C:\opt\scala-2.12.6\
C:\opt\dotty-0.8.0-RC1\
C:\opt\apache-ant-1.10.3\
c:\opt\gradle-4.7\
C:\opt\apache-maven-3.5.3\
C:\opt\sbt-1.1.6\
C:\opt\cfr-0_129\
C:\opt\Git-2.17.0\
</pre>

We further recommand using an advanced console emulator such as [ComEmu](https://conemu.github.io/) (or [Cmdr](http://cmder.net/)) which features [Unicode support](https://conemu.github.io/en/UnicodeSupport.html).

## Directory structure

This repository is organized as follows:
<pre style="font-size:80%;">
bin\*.bat
bin\0.8\*.bat
docs\
docs\cfr-0_129.zip
examples\{dotty-example-project, ..}
myexamples\{00_AutoParamTupling, ..}
README.md
setenv.bat
</pre>

where

- directory **`bin\`** provides several utility batch scripts.
- directory **`bin\0.8\`** contains the Dotty commands for **Microsoft Windows** (*see below*).
- directory **`docs\`** contains several Dotty related papers/articles.
- file **`docs\cfr-0_129.zip`** contains a zipped distribution of [CFR](http://www.benf.org/other/cfr/).
- directory **`examples\`** contains Dotty examples grabbed from various websites.
- directory **`myexamples\`** contains self-written examples.
- file **`README.md`** is the Markdown document for this page.
- file **`setenv.bat`** is the batch script for setting up our environment.

## Batch scripts

We distinguish different sets of batch scripts:

1. **`setenv.bat`** - This batch script makes external tools such as **`javac.exe`**, **`scalac.bat`**, **`dotc.bat`**, etc. directly available from the command prompt.

    <pre style="font-size:80%;">
    &gt; scalac -version
    Scala compiler version 2.12.6 -- Copyright 2002-2018, LAMP/EPFL and Lightbend, Inc.

    &gt; dotc -version
    Dotty compiler version 0.8.0-RC1 -- Copyright 2002-2018, LAMP/EPFL
    </pre>

2. Directory **`bin\`** - This directory contains several utility batch scripts:
   - **`cleanup.bat`** removes the generated class files from every example directory (both in **`examples\`** and **`myexamples\`** directories).
   - **`dirsize.bat`** prints the size in Kb/Mb/Gb of the specified directory paths.
   - **`getnightly.bat`** downloads the JAR libraries of the latest [Dotty nightly build](https://search.maven.org/#search|ga|1|g%3A%22ch.epfl.lamp%22).
   - **`searchjars.bat <class_name>`** searches for the given class name into all Dotty/Scala JAR files.
   - **`touch.bat`** updates the modification date of an existing file or creates a new one.<div style="font-size:8px;">&nbsp;</div>

3. Directory **`bin\0.8\`** - This directory contains batch files to be copied to the **`bin\`** directory of the Dotty installation (eg. **`C:\opt\dotty-0.8.0-RC1\bin\`**) in order to use the **`dotc`** and **`dot`** commands on **Microsoft Windows**.
    > **NB.** The author wrote (and does maintain) those batch files based on the bash scripts available from the standard [Dotty](http://dotty.epfl.ch/) distribution.

	<pre style="font-size:80%;">
	&gt; dir /b c:\opt\dotty-0.8.0-RC1\bin
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

    > **NB.** The `dotr.bat` batch file does hang on Windows due to implementation issues with the Dotty REPL on Windows.

4. **`build.bat`** - Finally every single example can be built/run using either  the **`build`** command or the **`sbt`** command.<br/>
    > **NB.** We prefer the **`build`** command here since our simple examples don't require the **`sbt`** machinery (eg. [library dependencies](https://www.scala-sbt.org/1.x/docs/Library-Dependencies.html), [sbt server](https://www.scala-sbt.org/1.x/docs/sbt-server.html)).

	<pre style="font-size:80%;">
	&gt; build
	Usage: build { options | subcommands }
	  Options:
	        -debug           show commands executed by this script
	        -deprecation     set compiler option -deprecation
	        -explain         set compiler option -explain
	        -compiler:<name>       select compiler (scala|scalac|dotc|dotty), default:dotc
	        -main:<name>           define main class name
	        -timer           display the compile time
	      Subcommands:
	        clean            delete generated class files
	        compile          compile source files (Java and Scala)
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

    Projects in **`examples\`** and **`myexamples\`** can also be built using **`ant`**, **`gradle`** or **`mvn`** as an alternative to the **`build`**/**`sbt`** tools:

	<pre style="font-size:80%;">
	> ant clean compile run
	...
	> gradle clean compileDotty run
	...
	> mvn clean compile exec:java
	</pre>
	
	> ***Gradle Wrappers***<br/>
	> We don't rely on them even if using [Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html) is the  recommended way to execute a Gradle build.<br/>
	> Simply execute the **`gradle wrapper`** command to generate the wrapper files; you can then run **`gradlew`** instead of **`gradle`**.

2. Decompiler tools

    As an alternative to the standard [**`javap`**](https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javap.html) class decompiler one may use **`cfr.bat`** (simply extract **`docs\cfr-0_129.zip`** to **`c:\opt\`**) which prints Java source code instead of just Java bytecode:

    <pre style="font-size:80%;">
    &gt; cfr myexamples\00_AutoParamTupling\target\dotty-0.8\classes\Main.class
	/*
	 * Decompiled with CFR 0_129.
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

    Here is the output from **`javap`** (with option **`-c`**) for the same class file:

    <pre style="font-size:80%;">
	&gt; javap -c target\dotty-0.8\classes\Main.class
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

## Session examples

#### `setenv.bat`

The **`setenv`** command is executed once to setup your development environment:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> setenv

> where sbt
C:\opt\sbt-1.1.6\bin\sbt
C:\opt\sbt-1.1.6\bin\sbt.bat
</pre>

> **NB.** Execute **`setenv help`** to display the help message.

With option **`-verbose`** the **`setenv`** command displays the version/path of the tools:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> setenv -verbose
JAVAC_VERSION=1.8.0_171
JAVA_VERSION=1.8.0_171
SCALAC_VERSION=2.12.6
DOTC_VERSION=0.8.0-RC1
ANT_VERSION=1.10.3
GRADLE_VERSION=4.7
MVN_VERSION=3.5.3
SBT_VERSION=1.1.6
CFR_VERSION=0_129
GIT_VERSION=2.17.0.windows.1
C:\Program Files\Java\jdk1.8.0_171\bin\javac.exe
C:\opt\scala-2.12.6\bin\scalac.bat
C:\opt\dotty-0.8.0-RC1\bin\dotc.bat
C:\opt\apache-ant-1.10.3\bin\ant.bat
c:\opt\gradle-4.7\bin\gradle.bat
C:\opt\apache-maven-3.5.3\bin\mvn.cmd
C:\opt\sbt-1.1.6\bin\sbt.bat
C:\opt\cfr-0_129\bin\cfr.bat
C:\opt\Git-2.17.0\bin\git.exe
</pre>

#### `cleanup.bat`

The **`cleanup`** command removes the output directories (ie. **`target\`**) from the example projets: 

<pre style="margin:10px 0 0 30px;font-size:80%;">
> cleanup
Finished to clean up 16 subdirectories in C:\dotty\examples
Finished to clean up 10 subdirectories in C:\dotty\myexamples
</pre>

#### `dirsize.bat {<dir_name>}`

The **`dirsize`** command returns the size (in Kb, Mb or Gb) of the specified directory paths:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> dirsize examples myexamples c:\opt\dotty-0.8.0-RC1
Size of directory "examples" is 6.3 Mb
Size of directory "myexamples" is 10.7 Mb
Size of directory "c:\opt\dotty-0.8.0-RC1" is 20.4 Mb
</pre>

#### `getnightly.bat`

The **`getnightly`** command downloads JAR library files from the latest Dotty nightly build on the [Maven Central Repository](https://search.maven.org/) and saves them into directory **`nightly-jars\`**:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> getnightly

> dir /b nightly-jars
dotty-compiler_0.8-0.8.0-bin-20180423-8feb596-NIGHTLY.jar
dotty-compiler_0.9-0.9.0-bin-20180502-d0f7846-NIGHTLY.jar
dotty-doc_0.8-0.8.0-bin-20180423-8feb596-NIGHTLY.jar
dotty-doc_0.9-0.9.0-bin-20180502-d0f7846-NIGHTLY.jar
dotty-interfaces-0.8.0-bin-20180423-8feb596-NIGHTLY.jar
dotty-interfaces-0.9.0-bin-20180502-d0f7846-NIGHTLY.jar
dotty-language-server_0.8-0.8.0-bin-20180423-8feb596-NIGHTLY.jar
dotty-language-server_0.9-0.9.0-bin-20180502-d0f7846-NIGHTLY.jar
dotty-library_0.8-0.8.0-bin-20180423-8feb596-NIGHTLY.jar
dotty-library_0.9-0.9.0-bin-20180502-d0f7846-NIGHTLY.jar
dotty_0.8-0.8.0-bin-20180423-8feb596-NIGHTLY.jar
dotty_0.9-0.9.0-bin-20180502-d0f7846-NIGHTLY.jar
</pre>

#### `searchjars.bat <class_name>`

Passing argument `System` to the **`searchjars`** command prints the following output (classfile names are printed with full path and are prefixed with their containing JAR file):
<pre style="margin:10px 0 0 30px;font-size:80%;">
> searchjars System
Search for class System in library files C:\opt\dotty-0.8.0-RC1\lib\*.jar
  scala-library-2.12.4.jar:scala/sys/SystemProperties$.class
  scala-library-2.12.4.jar:scala/sys/SystemProperties.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID$.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID.class
Search for class System in library files C:\opt\SCALA-~1.5\lib\*.jar
  scala-library.jar:scala/sys/SystemProperties$.class
  scala-library.jar:scala/sys/SystemProperties.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID$.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID.class
</pre>

Looking for the unknown class `BinarySearch` produces the following output:
<pre style="margin:10px 0 0 30px;font-size:80%;">
> searchjars BinarySearch
Search for class BinarySearch in library files C:\opt\dotty-0.8.0-RC1\lib\*.jar
Search for class BinarySearch in library files C:\opt\SCALA-~1.5\lib\*.jar
</pre>

#### `build.bat`

The **`build`** command is a basic build tool consisting of ~300 lines of batch/[Powershell ](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) code <sup id="anchor_02">[[2]](#footnote_02)</sup>. 

- Build/run the **`enum-Planet`** project with no build option:
<pre style="margin:10px 0 0 30px;font-size:80%;">
> build clean compile run
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
</pre>

- Build/run the **`enum-Planet`** project with build option **`-debug`**:
<pre style="margin:10px 0 0 30px;font-size:80%;">
> build -debug clean compile run
[build] _CLEAN=1 _COMPILE=1 _COMPILE_CMD=dotc _RUN=1
[build] del /s /q C:\dotty\examples\ENUM-P~1\target\dotty-0.8\classes\*.class C:\dotty\examples\ENUM-P~1\target\dotty-0.8\classes\*.hasTasty C:\dotty\examples\ENUM-P~1\target\dotty-0.8\classes\.latest-build
[build] 20180322224754 C:\dotty\examples\ENUM-P~1\src\main\scala\Planet.scala
[build] 00000000000000 C:\dotty\examples\ENUM-P~1\target\dotty-0.8\classes\.latest-build
[build] dotc  -classpath C:\dotty\examples\ENUM-P~1\target\dotty-0.8\classes -d C:\dotty\examples\ENUM-P~1\target\dotty-0.8\classes  C:\dotty\examples\ENUM-P~1\src\main\scala\Planet.scala
[build] dot -classpath C:\dotty\examples\ENUM-P~1\target\dotty-0.8\classes Planet 1
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
[build] _EXITCODE=0
</pre>

- Compilation of the Java/Scala source files is performed only if needed during the build process:

<pre style="margin:10px 0 0 30px;font-size:80%;">
> build clean

> build compile

> build compile
No compilation needed (1 source files)
</pre>


## Footnotes

<a name="footnote_01">[1]</a> ***2018-04-17*** [↩](#anchor_01)

<div style="margin:0 0 0 20px;">
Version 0.8 of the Dotty compiler is not compatible with versions 9 and 10 of <a href="https://docs.oracle.com/javase/9/install/overview-jdk-9-and-jre-9-installation.htm">Java JRE</a>; a <strong><code>java.lang.IncompatibleClassChangeError</code></strong> exception is thrown when starting the <strong><code>dotc</code></strong> command:
</div>

<!--
C:\Progra~1\Java\jre-10.0.1\bin\java.exe -Xmx768m -Xms768m -classpath C:\opt\dotty-0.8.0-RC1\lib\scala-library-2.12.4.jar;C:\opt\dotty-0.8.0-RC1\lib\scala-xml_2.12-1.0.6.jar;C:\opt\dotty-0.8.0-RC1\lib\scala-asm-6.0.0-scala-1.jar;C:\opt\dotty-0.8.0-RC1\lib\compiler-interface-1.1.4.jar;C:\opt\dotty-0.8.0-RC1\lib\dotty-interfaces-0.8.0-RC1.jar;C:\opt\dotty-0.8.0-RC1\lib\dotty-library_0.8-0.8.0-RC1.jar;C:\opt\dotty-0.8.0-RC1\lib\dotty-compiler_0.8-0.8.0-RC1.jar -Dscala.usejavacp=true dotty.tools.dotc.Main
-->

<pre style="margin:10px 0 0 20px;font-size:80%;">
> C:\Progra~1\Java\jre-10.0.1\bin\java.exe -Xmx768m -Xms768m \
-classpath C:\opt\dotty-0.8.0-RC1\lib\scala-library-2.12.4.jar; \
C:\opt\dotty-0.8.0-RC1\lib\scala-xml_2.12-1.0.6.jar; \
C:\opt\dotty-0.8.0-RC1\lib\scala-asm-6.0.0-scala-1.jar; \
C:\opt\dotty-0.8.0-RC1\lib\compiler-interface-1.1.4.jar; \
C:\opt\dotty-0.8.0-RC1\lib\dotty-interfaces-0.8.0-RC1.jar; \
C:\opt\dotty-0.8.0-RC1\lib\dotty-library_0.8-0.8.0-RC1.jar; \
C:\opt\dotty-0.8.0-RC1\lib\dotty-compiler_0.8-0.8.0-RC1.jar \
-Dscala.usejavacp=true dotty.tools.dotc.Main
Exception in thread "main" java.lang.IncompatibleClassChangeError: Method dotty.tools.dotc.core.Phases$PhasesBase.dotty$tools$dotc$core$Phases$PhasesBase$$initial$myTyperPhase()Ldotty/tools/dotc/core/Phases$Phase; must be InterfaceMethodref constant
        at dotty.tools.dotc.core.Contexts$ContextBase.<init>(Contexts.scala:544)
        at dotty.tools.dotc.Driver.initCtx(Driver.scala:39)
        at dotty.tools.dotc.Driver.process(Driver.scala:91)
        at dotty.tools.dotc.Driver.process(Driver.scala:108)
        at dotty.tools.dotc.Driver.main(Driver.scala:135)
        at dotty.tools.dotc.Main.main(Main.scala)
</pre>

> [***Oracle Java SE Support Roadmap***](http://www.oracle.com/technetwork/java/eol-135779.html)<br/>
> Oracle will not post further updates of Java SE 8 to its public download sites for commercial use after January 2019.

<a name="footnote_02">[2]</a> ***2018-05-09*** [↩](#anchor_02)

<div style="margin:0 0 0 20px;"> 
Command Prompt has been around for as long as we can remember, but starting with Windows 10 build 14971, Microsoft is trying to make PowerShell the <a href="https://support.microsoft.com/en-us/help/4027690/windows-powershell-is-replacing-command-prompt">main command shell</a> in the operating system.
</div>


*[mics](http://lampwww.epfl.ch/~michelou/)/April 2018*

