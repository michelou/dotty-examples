# Playing with Dotty

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" style="width:120px;"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers Dotty examples coming from various Web sites - including from the <a href="http://dotty.epfl.ch/">Dotty project</a> website - or written by myself.<br/>
  It also includes several batch scripts for experimenting with Dotty (aka Scala 3.0) on the <span style="font-weight:bold;font-style:italic;">Microsoft Windows</span> platform. </td>
  </tr>
</table>

## Project dependencies

This repository relies on a small set of external software installations for the ***Microsoft Windows*** plaform:

- [Oracle Java 8 SDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) (prerequisite for Scala 2.x and Dotty 0.7<sup id="anchor_01">[[1]](#footnote_01)</sup>)
- [Scala 2.x](https://www.scala-lang.org/download/)
- [Dotty 0.x](https://github.com/lampepfl/dotty/releases)
- [SBT 0.13 / 1.x](https://www.scala-sbt.org/download.html)

Optionally one may also install the following software:

- [Apache Ant 1.9](https://ant.apache.org/)
- [Apache Maven 3.5](http://maven.apache.org/download.cgi)
- [CFR 0.x](http://www.benf.org/other/cfr/) (Java decompiler)

> ***Installation rule***<br/>
> Whenever possible software is installed via a Zip archive rather than via a Windows installer.

In our environment the installation settings looks as follows (*by April 2018*):

<pre style="font-size:80%;">
C:\Program Files\Java\jdk1.8.0_171\
C:\opt\scala-2.12.5\
C:\opt\dotty-0.7.0-RC1\
C:\opt\apache-ant-1.9.2\
C:\opt\apache-maven-3.5.3\
C:\opt\sbt-1.1.4\
C:\opt\cfr-0_125\
</pre>

We further recommand using an advanced console emulator such as [ComEmu](https://conemu.github.io/) which features [UTF-8 support](https://conemu.github.io/en/UnicodeSupport.html).

## Directory structure

This repository is organized as follows:
<pre style="font-size:80%;">
bin\*.bat
bin\0.7\*.bat
docs\
examples\{dotty-example-project, ..}
myexamples\{00_AutoParamTupling, ..}
README.md
setenv.bat
</pre>

where

- directory **`bin\`** provides several utility batch scripts.
- directory **`bin\0.7\`** contains the Dotty commands for ***Microsoft Windows*** (*see below*).
- directory **`docs\`** contains several Dotty related papers/articles.
- directory **`examples\`** contains Dotty examples grabbed from various Web sites.
- directory **`myexamples\`** contains self-written examples.
- file **`README.md`** is the Markdown document for this page.
- file **`setenv.bat`** is the batch script for setting up our environment.

## Batch scripts

We distinguish different sets of batch scripts:

1. **`setenv.bat`** - this batch script makes the external tools such as **`javac.exe`**, **`scalac.bat`**, **`dotc.bat`**, etc. directly available from the command prompt.
    <pre style="font-size:75%;">
&gt; dotc -version
Dotty compiler version 0.7.0-RC1 -- Copyright 2002-2018, LAMP/EPFL
</pre>

2. Directory **`bin\`** - this directory contains utility batch scripts:
   - **`cleanup.bat`** removes the generated class files from every example directory (both in `examples` and `myexamples` directories).
   - **`dirsize.bat`** prints the size in Kb/Mb/Gb of the specified directory paths.
   - **`getnightly.bat`** downloads the JAR libraries of the latest Dotty nightly build.
   - **`searchjars.bat <class_name>`** searches for the given class name into all Dotty/Scala jar files.
   - **`touch.bat`** updates the modification date of an existing file or creates a new one.<div style="font-size:8px;">&nbsp;</div>

3. Directory **`bin\0.7\`** - its contents must be copied to directory `C:\opt\dotty-0.7.0-RC1\bin\` (please adapt the target path to match your settings) in order to use the **`dotc`** and **`dot`** commands.
    > **NB.** The author wrote (and maintain) those batch files based on the bash scripts found in the standard Dotty distribution.

    <pre style="font-size:80%;">
&gt; dir /b c:\opt\dotty-0.7.0-RC1\bin
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

4. Finally every single example can be built/run using either  the **`build`** command (batch script **`build.bat`**) or the **`sbt`** command.<br/>
    **NB.** We prefer the **`build.`** command here since our simple examples don't require the **`sbt`** machinery (eg. [library dependencies](https://www.scala-sbt.org/1.x/docs/Library-Dependencies.html), [sbt server](https://www.scala-sbt.org/1.x/docs/sbt-server.html)):

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
    </pre>

## Session examples

#### `setenv.bat`

Here is the output of `setenv.bat` in our environment settings:
<pre style="margin:10px 0 0 30px;font-size:80%;">
> setenv.bat
JAVAC_VERSION=1.8.0_171
JAVA_VERSION=1.8.0_171
SCALAC_VERSION=2.12.5
DOTC_VERSION=0.7.0-RC1
ANT_VERSION=1.9.2
MVN_VERSION=3.5.3
SBT_VERSION=1.1.4
C:\Program Files\Java\jdk1.8.0_171\bin\javac.exe
C:\opt\scala-2.12.5\bin\scalac.bat
C:\opt\dotty-0.7.0-RC1\bin\dotc.bat
C:\opt\sbt-1.1.4\bin\sbt.bat
C:\opt\cfr-0_125\bin\cfr.bat

> where sbt
C:\opt\sbt-1.1.4\bin\sbt
C:\opt\sbt-1.1.4\bin\sbt.bat
</pre>

#### `cleanup.bat`

<pre style="margin:10px 0 0 30px;font-size:80%;">
> cleanup.bat
Finished to clean up 14 subdirectories in C:\dotty\examples
Finished to clean up 3 subdirectories in C:\dotty\myexamples
</pre>

#### `dirsize.bat {<class_name>}`

<pre style="margin:10px 0 0 30px;font-size:80%;">
> dirsize examples myexamples c:\opt\dotty-0.7.0-RC1
Size of directory "examples" is 6.3 Mb
Size of directory "myexamples" is 10.7 Mb
Size of directory "c:\opt\dotty-0.7.0-RC1" is 20.5 Mb
</pre>

#### `getnightly.bat`

<pre style="margin:10px 0 0 30px;font-size:80%;">
> getnightly

> dir /b nightly-jars
dotty-compiler_0.8-0.8.0-bin-20180418-553ead0-NIGHTLY.jar
dotty-doc_0.8-0.8.0-bin-20180418-553ead0-NIGHTLY.jar
dotty-interfaces-0.8.0-bin-20180418-553ead0-NIGHTLY.jar
dotty-language-server_0.8-0.8.0-bin-20180418-553ead0-NIGHTLY.jar
dotty-library_0.8-0.8.0-bin-20180418-553ead0-NIGHTLY.jar
dotty_0.8-0.8.0-bin-20180418-553ead0-NIGHTLY.jar
</pre>

#### `searchjars.bat <class_name>`

Here is the output of `searchjars.bat` with parameter `class_name`=**`System`** (classfile names are printed with full path and are prefixed with their containing jar file):
<pre style="margin:10px 0 0 30px;font-size:80%;">
> searchjars System
Search for class System in library files C:\opt\dotty-0.7.0-RC1\lib\*.jar
  scala-library-2.12.5.jar:scala/sys/SystemProperties$.class
  scala-library-2.12.5.jar:scala/sys/SystemProperties.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID$.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID.class
Search for class System in library files C:\opt\SCALA-~1.5\lib\*.jar
  scala-library.jar:scala/sys/SystemProperties$.class
  scala-library.jar:scala/sys/SystemProperties.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID$.class
  scala-xml_2.12-1.0.6.jar:scala/xml/dtd/SystemID.class
</pre>

Looking for the unknown class **`BinarySearch`** produces the following output:
<pre style="margin:10px 0 0 30px;font-size:80%;">
> searchjars Nobody
Search for class BinarySearch in library files C:\opt\dotty-0.7.0-RC1\lib\*.jar
Search for class BinarySearch in library files C:\opt\SCALA-~1.5\lib\*.jar
</pre>

#### `build.bat`

- Build/run the **`enum-Planet`** without build option:
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

- Build/run the **`enum-Planet`** with build option **`-debug`**:
<pre style="margin:10px 0 0 30px;font-size:80%;">
> build -debug clean compile run
[build] _CLEAN=1 _COMPILE=1 _COMPILE_CMD=dotc _RUN=1
[build] del /s /q C:\dotty\examples\ENUM-P~1\target\dotty-0.7\classes\*.class C:\dotty\examples\ENUM-P~1\target\dotty-0.7\classes\*.hasTasty C:\dotty\examples\ENUM-P~1\target\dotty-0.7\classes\.latest-build
[build] 20180322224754 C:\dotty\examples\ENUM-P~1\src\main\scala\Planet.scala
[build] 00000000000000 C:\dotty\examples\ENUM-P~1\target\dotty-0.7\classes\.latest-build
[build] dotc  -classpath C:\dotty\examples\ENUM-P~1\target\dotty-0.7\classes -d C:\dotty\examples\ENUM-P~1\target\dotty-0.7\classes  C:\dotty\examples\ENUM-P~1\src\main\scala\Planet.scala
[build] dot -classpath C:\dotty\examples\ENUM-P~1\target\dotty-0.7\classes Planet 1
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

- Compilation is performed only if needed during the build process:
<pre style="margin:10px 0 0 30px;font-size:80%;">
> build clean

> build compile

> build compile
No compilation needed (1 source files)
</pre>


## Footnotes

<a name="footnote_01">[1]</a> ***2018-04-17*** [↩](#anchor_01)

<div style="margin:0 0 0 20px;">
Version 0.7 of the Dotty compiler is not compatible with versions 9 and 10 of Java JRE; a <strong><code>java.lang.IncompatibleClassChangeError</code></strong> exception is thrown when starting the <strong><code>dotc</code></strong> command:
</div>

<pre style="margin:10px 0 0 20px;font-size:80%;">
> C:\Progra~1\Java\jre-10.0.1\bin\java.exe \
-Xmx768m -Xms768m \
-classpath C:\opt\DOTTY-~2.0-R\lib\scala-library-2.12.4.jar;\
C:\opt\DOTTY-~2.0-R\lib\dotty-library_0.7-0.7.0-RC1.jar;\
C:\opt\DOTTY-~2.0-R\lib\scala-asm-6.0.0-scala-1.jar;\
C:\opt\DOTTY-~2.0-R\lib\sbt-interface-0.13.15.jar;\
C:\opt\DOTTY-~2.0-R\lib\dotty-interfaces-0.7.0-RC1.jar;\
C:\opt\DOTTY-~2.0-R\lib\dotty-library_0.7-0.7.0-RC1.jar;\
C:\opt\DOTTY-~2.0-R\lib\dotty-compiler_0.7-0.7.0-RC1.jar \
-Dscala.usejavacp=true dotty.tools.dotc.Main
Exception in thread "main" java.lang.IncompatibleClassChangeError: Method dotty.tools.dotc.core.Phases$PhasesBase.dotty$tools$dotc$core$Phases$PhasesBase$$initial$myTyperPhase()Ldotty/tools/dotc/core/Phases$Phase; must be InterfaceMethodref constant
        at dotty.tools.dotc.core.Contexts$ContextBase.<init>(Contexts.scala:542)
        at dotty.tools.dotc.Driver.initCtx(Driver.scala:39)
        at dotty.tools.dotc.Driver.process(Driver.scala:91)
        at dotty.tools.dotc.Driver.process(Driver.scala:108)
        at dotty.tools.dotc.Driver.main(Driver.scala:135)
        at dotty.tools.dotc.Main.main(Main.scala)

</pre>

> ***[Oracle Java SE Support Roadmap](http://www.oracle.com/technetwork/java/eol-135779.html)***<br/>
> Oracle will not post further updates of Java SE 8 to its public download sites for commercial use after January 2019.

*[mics](http://lampwww.epfl.ch/~michelou/)/April 2018*






