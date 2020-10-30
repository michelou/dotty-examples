# <span id="top">Scala 3 examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:100px;" src="../docs/dotty.png" width="100" alt="Dotty logo"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>myexamples\</code></strong> contains <a href="https://dotty.epfl.ch/" rel="external" title="Scala 3">Scala 3</a> code examples written by myself.
  </td>
  </tr>
</table>

Let's choose example [**`myexamples\HelloWorld`**](HelloWorld) to demonstrate the usage of the build tools we do support:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cd">cd</a></b>
W:\myexamples\HelloWorld
</pre>

Build tools rely on one or more configuration files to achieve their tasks. In our case we created the following configuration files for [**`HelloWorld`**](HelloWorld):

| Build tool                    | Configuration file(s)                                   | Parent file(s)                       |
|-------------------------------|---------------------------------------------------------|--------------------------------------|
| [**`ant.bat`**][apache_ant_cli]   | [**`build.xml`**](HelloWorld/build.xml)                 | [**`build.xml`**](build.xml), [**`ivy.xml`**](ivy.xml) |
| [**`bazel.exe`**][bazel_cli]      | [**`BUILD`**](HelloWorld/BUILD), **`WORKSPACE`**        | n.a.                                 |
| **`build.bat`**                   | [**`build.properties`**](HelloWorld/project/build.properties) | n.a.                           |
| [**`gradle.bat`**][gradle_cli]    | [**`build.gradle`**](HelloWorld/build.gradle)           | [**`common.gradle`**](common.gradle) |
| [**`make.exe`**][gmake_cli]       | [**`Makefile`**](HelloWorld/Makefile)                   | [**`Makefile.inc`**](Makefile.inc)   |
| [**`mill.bat`**][mill_cli]        | [**`build.sc`**](HelloWorld/build.sc)                   | [**`common.sc`**](common.sc)         |
| [**`mvn.cmd`**][apache_maven_cli] | [**`pom.xml`**](HelloWorld/pom.xml)                     | [**`pom.xml`**](pom.xml)             |
| [**`sbt.bat`**][sbt_cli]          | [**`build.sbt`**](HelloWorld/build.sbt)                 | n.a.                                 |


## <span id="ant">Ant build tool</span>

The configuration file [**`HelloWorld\build.xml`**](HelloWorld/build.xml) depends on the parent file [**`myexamples\build.xml`**](build.xml) which provides the macro definition **`dotc`** to compile the Scala source files.

> **:mag_right:** Command [**`ant`**][apache_ant_cli] (["Another Neat Tool"][apache_ant_faq]) is a Java-based build maintained by the [Apache Software Foundation][apache_ant_history] (tool created in 2000). It works with XML-based configuration files.

Execution of [**`HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output ([Ivy][apache_ant_ivy] support is enabled by default):

<pre style="font-size:80%;">
<b>&gt; <a href="https://ant.apache.org/manual/running.html#commandline">ant</a> clean run</b>
Buildfile: W:\myexamples\HelloWorld\build.xml

<span style="font-weight:bold;color:#9966ff;">clean:</span>
   [delete] Deleting directory W:\myexamples\HelloWorld\target

<span style="font-weight:bold;color:#9966ff;">init.local:</span>

<span style="font-weight:bold;color:#9966ff;">init.ivy:</span>
[ivy:resolve] :: Apache Ivy 2.5.0 - 20191020104435 :: https://ant.apache.org/ivy/ ::
[ivy:resolve] :: loading settings :: url = jar:file:/C:/opt/apache-ant-1.10.7/lib/ivy-2.5.0.jar!/org/apache/ivy/core/settings/ivysettings.xml

<span style="font-weight:bold;color:#9966ff;">init:</span>

<span style="font-weight:bold;color:#9966ff;">compile:</span>
    [mkdir] Created dir: W:\myexamples\HelloWorld\target\classes
   [scalac] Compiling 1 source file to W:\myexamples\HelloWorld/target/classes

<span style="font-weight:bold;color:#9966ff;">run:</span>
     [java] Hello world!

BUILD SUCCESSFUL
Total time: 3 seconds
</pre>

> **&#9755;** **Apache Ivy**<br/>
> We observe from task **`init.ivy`** that the [Apache Ivy][apache_ant_ivy] library has been added to the [Ant](https://ant.apache.org/) installation directory. In our case we installed [version 2.5.0][apache_ant_ivy_relnotes] of the [Apache Ivy][apache_ant_ivy] library.
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://curl.haxx.se/docs/manual.html">curl</a> -sL -o c:\Temp\apache-ivy-2.5.0.zip https://www-eu.apache.org/dist//ant/ivy/2.5.0/apache-ivy-2.5.0-bin.zip</b>
> <b>&gt; unzip c:\temp\apache-ivy-2.5.0.zip -d c:\opt</b>
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/copy">copy</a> c:\opt\apache-ivy-2.5.0\ivy-2.5.0.jar c:\opt\apache-ant-1.10.8\lib</b>
> <b>&gt; dir c:\opt\apache-ant-1.10.8\lib | findstr ivy</b>
> 20.10.2019  09:44         1 402 646 ivy-2.5.0.jar
> </pre>

We can set property **`-Duse.local=true`** to use the Scala 3 local installation (*reminder*: variable **`SCALA3_HOME`** is set by command **`setenv`**):

<pre style="font-size:80%;">
<b>&gt;</b> <a href="https://ant.apache.org/manual/running.html#commandline">ant</a> -Duse.local=true clean run
Buildfile: W:\myexamples\HelloWorld\build.xml

<span style="font-weight:bold;color:#9966ff;">clean:</span>
   [delete] Deleting directory W:\myexamples\HelloWorld\target

<span style="font-weight:bold;color:#9966ff;">init.local:</span>
     [echo] SCALA3_HOME=C:\opt\scala-3.0.0-M1

<span style="font-weight:bold;color:#9966ff;">init.ivy:</span>

<span style="font-weight:bold;color:#9966ff;">init:</span>

<span style="font-weight:bold;color:#9966ff;">compile:</span>
    [mkdir] Created dir: W:\myexamples\HelloWorld\target\classes
   [scalac] Compiling 1 source file to W:\myexamples\HelloWorld/target/classes

<span style="font-weight:bold;color:#9966ff;">run:</span>
     [java] Hello world!

BUILD SUCCESSFUL
Total time: 14 seconds
</pre>


## <span id="build">`build.bat` command</span>

Command [**`build`**](HelloWorld/build.bat) is a basic build tool consisting of ~700 lines of batch/[Powershell ][microsoft_powershell] code <sup id="anchor_01">[[1]](#footnote_01)</sup> featuring subcommands **`clean`**, **`compile`**, **`doc`**, **`help`** and **`run`**.

Command [**`build clean run`**](HelloWorld/build.bat) produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="HelloWorld/build.bat">build</a> clean run</b>
Hello world!
</pre>


## <span id="gradle">Gradle build tool</span>

Command [**`gradle`**][gradle_cli] is the official build tool for Android applications (tool created in 2007). It replaces XML-based build scripts with a [Groovy][gradle_groovy]-based DSL.

> **&#9755;** ***Gradle Wrappers***<br/>
> We don't rely on them even if using [Gradle Wrapper][gradle_wrapper] is the  recommended way to execute a Gradle build.<br/>
> Simply execute the **`gradle wrapper`** command to generate the wrapper files; you can then run **`gradlew`** instead of [**`gradle`**][gradle_cli].

The configuration file [**`HelloWorld\build.gradle`**](HelloWorld/build.gradle) looks as follows:

<pre style="font-size:80%;">
plugins {
    id <span style="color:#990000;">"java"</span>
}
&nbsp;
group <span style="color:#990000;">"$appGroup"</span>
version <span style="color:#990000;">"$appVersion"</span>
&nbsp;
description <span style="color:#990000;">"""Gradle example project to build/run Scala 3 applications"""</span>
&nbsp;
apply from: <span style="color:#990000;">"../common.gradle"</span>
&nbsp;
run.doFirst {
    args <span style="color:#990000;">""</span>
}
</pre>

[**`build.gradle`**](HelloWorld/build.gradle) loads properties from file [**`gradle.properties`**](HelloWorld/gradle.properties) and imports code from parent file [**`myexamples\common.gradle`**](common.gradle).

The parent file [**`myexamples\common.gradle`**](common.gradle) defines the task **`compileDotty`** and manages the task dependencies.

<pre style="font-size:80%;">
<i style="color:#009900;">// overrides default "/build"</i>
buildDir file(<span style="color:#990000;">"/target"</span>)

java {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
}
ext {
    ...
    classesDir = file(<span style="color:#990000;">"${buildDir}/classes"</span>)
    <b>if</b> (dottyLocal?.toBoolean()) {
        dottyHome = System.getenv(<span style="color:#990000;">"SCALA3_HOME"</span>)
        print(<span style="color:#990000;">"SCALA3_HOME=$dottyHome"</span>)
        ...
    }
}
clean.doLast {
    targetDir.deleteDir()
}
<b>task</b> compileDotty(type: JavaExec) {
    dependsOn compileJava
    ...
    main <span style="color:#990000;">"dotty.tools.dotc.Main"</span>
}
compileDotty.doFirst {
    if (!classesDir.exists()) classesDir.mkdirs()
}
build {
    dependsOn compileDotty
}
<b>task</b> run(type: JavaExec) {
    dependsOn build
    ...
    <b>if</b> (mainClassName?.trim()) main mainClassName
    <b>else</b> main <span style="color:#990000;">"Main"</span>
    if (args == null) args <span style="color:#990000;">""</span>
}
...
</pre>

Command **`gradle clean run`** produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.gradle.org/current/userguide/command_line_interface.html">gradle</a> clean run</b>

&gt; Task :run
Hello world!

BUILD SUCCESSFUL in 4s
7 actionable tasks: 7 executed
</pre>

## <span id="gmake">Make build tool</span>

The configuration file [**`HelloWorld\Makefile`**](HelloWorld/Makefile) depends on the parent file [**`myexamples\Makefile.inc`**](Makefile.inc) which defines common settings (i.e. tool and library paths).

> **:mag_right:** Command [**`make`**][gmake_cli] is a build tool that automatically builds executable programs and libraries from source code by reading files called Makefiles which specify how to derive the target program. [Make] was originally created by Stuart Feldman in April 1976 at Bell Labs.

Command **`make clean run`** produces the following output ([**`HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala)):

<pre style="font-size:80%;">
<b>&gt; <a href="http://www.glue.umd.edu/lsf-docs/man/gmake.html">make</a> clean run</b>
rm -rf "target"
[ -d "target/classes" ] || mkdir -p "target/classes"
dotc.bat "@target/scalac_opts.txt" "@target/scalac_sources.txt"
dotr.bat -classpath "target/classes" myexamples.HelloWorld 2
Hello world!
</pre>

Command **`make test`** executes the test suite [**`HelloWorldTest.scala`**](HelloWorld/src/test/scala/HelloWorldTest.scala) for program [**`HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala).

<pre style="font-size:80%;">
<b>&gt; <a href="http://www.glue.umd.edu/lsf-docs/man/gmake.html">make</a> test</b>
[ -d "target/test-classes" ] || mkdir -p "target/test-classes"
dotc.bat "@target/scalac_test_opts.txt" "@target/scalac_test_sources.txt"
java.exe -classpath "%USERPROFILE%/.m2/repository/org/scala-lang/scala-library/2.13.2/scala-library-2.13.2.jar;%USERPROFILE%/.m2/repository/ch/epfl/lamp/dotty-library_0.27/0.27.0-RC1/dotty-library_0.27-0.27.0-RC1.jar;%USERPROFILE%/.m2/repository/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar;%USERPROFILE%/.m2/repository/junit/junit/4.13/junit-4.13.jar;%USERPROFILE%/.m2/repository/com/novocode/junit-interface/0.11/junit-interface-0.11.jar;%USERPROFILE%/.m2/repository/org/scalatest/scalatest_2.13/3.2.0/scalatest_2.13-3.2.0.jar;%USERPROFILE%/.m2/repository/org/scalactic/scalactic_2.13/3.2.0/scalactic_2.13-3.2.0.jar;%USERPROFILE%/.m2/repository/org/specs2/specs2-core_2.13/4.10.1/specs2-core_2.13-4.10.1.jar;%USERPROFILE%/.m2/repository/org/specs2/specs2-junit_2.13/4.10.1/specs2-junit_2.13-4.10.1.jar;%USERPROFILE%/.m2/repository/org/specs2/specs2-matcher_2.13/4.10.1/specs2-matcher_2.13-4.10.1.jar;target/classes;target/test-classes" org.junit.runner.JUnitCore myexamples.HelloWorldTest
JUnit version 4.13
.
Time: 0.201

OK (1 test)
</pre>

Command **`make test`** generates the HTML documentation for program [**`HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala):

<pre style="font-size:80%;">
<b>&gt; <a href="http://www.glue.umd.edu/lsf-docs/man/gmake.html">make</a> doc</b>
[ -d "target/docs" ] || mkdir -p "target/docs"
dotd.bat "@target/scaladoc_opts.txt" "@target/scaladoc_sources.txt"
Compiling (1/1): HelloWorld.scala
[doc info] Generating doc page for: myexamples
[doc info] Generating doc page for: myexamples.HelloWorld$
[doc info] Generating doc page for: myexamples.HelloWorld$
[...]
public members with docstrings:    0
protected members with docstrings: 0
private members with docstrings:   0
</pre>


## Maven build tool

The configuration file [**`HelloWorld\pom.xml`**](HelloWorld/pom.xml) depends on the parent file [**`myexamples\pom.xml`**](pom.xml) which defines common properties (eg. **`java.version`**, **`scala.version`**).

> **:mag_right:** Command [**`mvn`**][apache_maven_cli] is a Java-based build tool maintained by the [Apache Software Foundation][apache_maven_history] (tool created in 2002). It works with XML-based configuration files and provides a way to share JARs across several projects.

Command **`mvn clean test`** with option **`-debug`** produces additional debug information, including the underlying command lines executed by our Maven plugin **`scala-maven-plugin`**:

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/run.html">mvn</a> -debug clean test | findstr /b /c:"[DEBUG]\ [execute]" 2>NUL</b>
[DEBUG] [execute] C:\opt\jdk-11.0.9+11\bin\java.exe \
 -Xms64m -Xmx1024m -Dscala.home=C:\opt\scala-3.0.0-M1 \
 -cp C:\opt\scala-3.0.0-M1\lib\*.jar -Dscala.usejavacp=true  \
 dotty.tools.dotc.Main \
 -classpath W:\dotty-examples\examples\hello-scala\target\classes \
 -d W:\dotty-examples\examples\hello-scala\target\classes \
 W:\dotty-examples\examples\hello-scala\src\main\scala\hello.scala
[DEBUG] [execute] C:\opt\jdk-11.0.9+11\bin\java.exe \
 -Xms64m -Xmx1024m -Dscala.home=C:\opt\scala-3.0.0-M1 [...]
[DEBUG] [execute] C:\opt\jdk-11.0.9+11\bin\java.exe \
 -Xms64m -Xmx1024m -cp C:\opt\scala-3.0.0-M1\lib\*.jar;\
W:\dotty-examples\examples\hello-scala\target\classes hello
</pre>

Execution of [**`HelloWorld\src\main\scala\HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output (option **`--quiet`** tells Maven not to display anything other than **`ERROR`** level messages):

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/run.html">mvn</a> --quiet clean test</b>
Hello world!
</pre>

We can also specify phase **`package`** to generate (and maybe execute) the **`HelloWorld`** Java archive:

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/run.html">mvn</a> clean package</b>
[INFO] Scanning for projects...
[INFO]
[INFO] --------------------< dotty.myexamples:HelloWorld >---------------------
[INFO] Building HelloWorld 0.1-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[..]
[INFO] --- maven-jar-plugin:3.1.1:jar (default-jar) @ HelloWorld ---
[INFO] Building jar: W:\myexamples\HelloWorld\target\HelloWorld-0.1-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  5.635 s
[INFO] Finished at: 2019-01-31T13:53:22+01:00
[INFO] ------------------------------------------------------------------------
</pre>

> **&#9755;** **Scala Maven Plugin**<br/>
> In the Maven configuration file we note the presence of the Maven plugin [**`scala-maven-plugin`**](../bin/scala-maven-plugin-1.0.zip). In fact the parent file [**`examples\pom.xml`**](pom.xml) depends on [**`scala-maven-plugin`**](../bin/scala-maven-plugin-1.0.zip), a Maven plugin we developed specifically for this project:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/more">more</a> ..\pom.xml</b>
> &lt;?xml version="1.0" encoding="UTF-8"?&gt;
> ...
>     <b>&lt;properties&gt;</b>
>         <b>&lt;project.build.sourceEncoding&gt;</b>UTF-8<b>&lt;/project.build.sourceEncoding&gt;</b>
>         <b>&lt;java.version&gt;</b>1.8<b>&lt;/java.version&gt;</b>
> &nbsp;
>         <i style="color:#66aa66;">&lt;!-- Scala settings --&gt;</i>
>         <b>&lt;scala.version&gt;</b>0.27.0-RC1<b>&lt;/scala.version&gt;</b>
>         <b>&lt;scala.local.install&gt;</b>true<b>&lt;/scala.local.install&gt;</b>
> &nbsp;
>         <i style="color:#66aa66;">&lt;!-- Maven plugins --&gt;</i>
>         <b>&lt;scala.maven.version&gt;</b>1.0-SNAPSHOT<b>&lt;/scala.maven.version&gt;</b>
>         ...
>     <b>&lt;/properties&gt;</b>
>     <b>&lt;dependencies&gt;</b>
>         <b>&lt;dependency&gt;</b>
>             <b>&lt;groupId&gt;</b>ch.epfl.alumni<b>&lt;/groupId&gt;</b>
>             <b>&lt;artifactId&gt;</b>scala-maven-plugin<b>&lt;/artifactId&gt;</b>
>             <b>&lt;version&gt;</b>${scala.maven.version}<b>&lt;/version&gt;</b>
>         <b>&lt;/dependency&gt;</b>
>         ...
>     <b>&lt;/dependencies&gt;</b>
>
> <b>&lt;/project&gt;</b>
> </pre>
> The plugin is available as [Zip archive][zip_archive] and its installation is deliberately very simple:
> <pre style="font-size:80%;">
> <b>&gt; unzip ..\bin\scala-maven-plugin-1.0.zip %USERPROFILE%\.m2\repository\</b>
> <b>&gt; tree /a /f %USERPROFILE%\.m2\repository\ch\epfl\alumni | findstr /v "^[A-Z]"</b>
> |   maven-metadata-local.xml
> |
> \---scala-maven-plugin
>     |   maven-metadata-local.xml
>     |
>     \---1.0-SNAPSHOT
>             maven-metadata-local.xml
>             scala-maven-plugin-1.0-SNAPSHOT.jar
>             scala-maven-plugin-1.0-SNAPSHOT.pom
>             _remote.repositories
> </pre>

Finally can check the Java manifest in **`HelloWorld-0.1-SNAPSHOT.jar`**:

<pre style="font-size:80%;">
<b>&gt;</b> java -Xbootclasspath/a:c:\opt\scala-3.0.0-M1\lib\dotty-library_3.0.0-M1-3.0.0-M1.jar;^
c:\opt\scala-3.0.0-M1\lib\scala-library-2.13.3.jar ^
-jar target\HelloWorld-0.1-SNAPSHOT.jar
Hello world!
</pre>

> **:mag_right:** We can use batch script [**`searchjars`**](../bin/searchjars.bat) in case some class is missing in the specified classpath, e.g.
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html">java</a> -Xbootclasspath/a:c:\opt\scala-3.0.0-M1\lib\dotty-library_3.0.0-M1-3.0.0-M1.jar -jar target\enum-Color-0.1-SNAPSHOT.jar</b>
> Exception in thread "main" java.lang.NoClassDefFoundError: scala/Serializable
>         [...]
>         at Main.main(Main.scala)
> Caused by: java.lang.ClassNotFoundException: scala.Serializable
>         [...]
>         ... 13 more
> 
> <b>&gt; searchjars Serializable</b>
> Searching for class name Serializable in library files C:\opt\dotty-0.27.0-RC1\lib\*.jar
>   jackson-core-2.9.8.jar:com/fasterxml/jackson/core/SerializableString.class
>   [...]
>   scala-library-2.13.3.jar:scala/collection/generic/DefaultSerializable.class
> Searching for class name Serializable in library files C:\opt\scala-2.13.3\lib\*.jar
>   scala-library.jar:scala/collection/generic/DefaultSerializable.class
> Searching for class name Serializable in library files C:\opt\jdk-11.0.8+10\lib\*.jar
> Searching for class name Serializable in archive files C:\opt\javafx-sdk-14.0.2.1\lib\*.jar
> </pre>
> Class **`scala.Serializable`** is part of **`C:\opt\scala-3.0.0-M1\lib\scala-library-2.13.3.jar`**, so let us add it to our classpath !


## <span id="mill">Mill build tool</span>

The configuration file [**`build.sc`**](HelloWorld/build.sc) depends on the parent file [**`myexamples\common.sc`**](common.sc) which defines the common settings.
It is a standalone file written in Scala (with direct access to [OS-Lib][os_lib]).

> **:mag_right:** Command [**`mill`**][mill_cli] is a Scala-based build tool which aims for simplicity to build projects in a fast and predictable manner.

Command [**`mill -i app`**](HelloWorld/build.sc) produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="https://www.lihaoyi.com/mill/#command-line-tools">mill</a> -i app</b>
[38/38] app.run
Hello world!
</pre>


## <span id="sbt">SBT build tool</span>

The configuration file [**`build.sbt`**](HelloWorld/build.sbt) is written in [Scala] and obeys the [sbt build definitions](https://www.scala-sbt.org/1.0/docs/Basic-Def.html).

> **:mag_right:** [Lightbend] provides commercial support for the [**`sbt`**][sbt_cli] build tool.

Command **`sbt -warn clean run`** produces the following output:

<pre style="font-size:80%;">
<b>&gt; sbt -warn clean run</b>
Hello world!
</pre>

## <span id="footnotes">Footnotes</span>

<dl>
<dt><b name="footnote_01">&nbsp;&nbsp;[1]&nbsp;&nbsp; <i>Batch files and coding conventions</i></b> <a href="#anchor_01">↩</a></dt>
<dd>
<p>
Batch files (e.g. <a href="HelloWorld/build.bat"><b><code>HelloWorld\build.bat</code></b></a>) obey the following coding conventions:

- We use at most 80 characters per line. In general we would say that 80 characters fit well with 4:3 screens and 100 characters fit well with 16:9 screens ([Google's convention](https://google.github.io/styleguide/javaguide.html#s4.4-column-limit) is 100 characters).
- We organize our code in 4 sections: `Environment setup`, `Main`, `Subroutines` and `Cleanups`.
- We write exactly ***one exit instruction*** (label **`end`** in section **`Cleanups`**).
- We adopt the following naming conventions: global variables start with character `_` (shell variables defined in the user environment start with a letter) and local variables (e.g. inside subroutines or  **`if/for`** constructs) start with `__` (two `_` characters).
</p>

<pre style="font-size:80%;">
<b>@echo off</b>
<b>setlocal enabledelayedexpansion</b>
...
<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Environment setup</i>

<b>set</b> _EXITCODE=0

<b>call <span style="color:#9966ff;">:env</span></b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <b>goto <span style="color:#9966ff;">end</span></b>

<b>call <span style="color:#9966ff;">:props</span></b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <b>goto <span style="color:#9966ff;">end</span></b>

<b>call <span style="color:#9966ff;">:args</span> %*</b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <b>goto <span style="color:#9966ff;">end</span></b>

<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Main</i>

<b>if</b> %_CLEAN%==1 (
    <b>call :clean</b>
    <b>if not</b> !_EXITCODE!==0 <b>goto end</b>
)
<b>if</b> %_COMPILE%==1 (
    <b>call <span style="color:#9966ff;">:compile</span></b>
    <b>if not</b> !_EXITCODE!==0 <b>goto end</b>
)
<b>if</b> %_DOC%==1 (
    <b>call <span style="color:#9966ff;">:doc</span></b>
    <b>if not</b> !_EXITCODE!==0 <b>goto end</b>
)
<b>if</b> %_RUN%==1 (
    <b>call <span style="color:#9966ff;">:run</span></b>
    <b>if not</b> !_EXITCODE!==0 <b>goto end</b>
)
<b>goto <span style="color:#9966ff;">end</span></b>

<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Subroutines</i>

<span style="color:#9966ff;">:env</span>
...<i>(variable initialization, eg. directory paths)</i>...
<b>goto :eof</b>
<span style="color:#9966ff;">:props</span>
...<i>(read file build.properties if present)</i>...
<b>goto :eof</b>
<span style="color:#9966ff;">:args</span>
...<i>(command line options/subcommands)</i>...
<b>goto :eof</b>
<span style="color:#9966ff;">:clean</span>
...<i>(delete generated files/directories)</i>...
<b>goto :eof</b>
<span style="color:#9966ff;">:compile</span>
...
<b>goto :eof</b>
<span style="color:#9966ff;">:doc</span>
...
<b>goto :eof</b>
<span style="color:#9966ff;">:run</span>
...
<b>goto :eof</b>

<i style="color:#66aa66;">@rem ##########################################################################
@rem ## Cleanups</i>

<span style="color:#9966ff;">:end</span>
...
<b>exit</b> /b <span style="color:#3333ff;">%_EXITCODE%</span>
</pre>
</dd>

<dt><b name="footnote_02">&nbsp;&nbsp;[2]&nbsp;&nbsp; <a href="https://github.com/lampepfl/dotty/issues/4272" style="font-weight:bold;">bug4272</a> <i>2018-04-08</i></b> <a href="#anchor_02">↩</a></dt>
<dd>
<p>
Executing command <a href="bug4272/build.bat" style="font-weight:bold;font-family:Courier;">build</a> in directory <a href="bug4272/" style="font-weight:bold;font-family:Courier;">bug4272\</a> produces a runtime exception with version 0.7 of the Dotty compiler (*was fixed in version 0.8*):
</p>
<pre style="font-size:80%;">
<b>&gt; build clean compile run</b>
exception occurred while typechecking C:\dotty\MYEXAM~1\bug4272\src\main\scala\Main.scala
exception occurred while compiling C:\dotty\MYEXAM~1\bug4272\src\main\scala\Main.scala
Exception in thread "main" java.lang.AssertionError: cannot merge Constraint(
 uninstVars = A;
 constrained types = [A, B](elems: (A, B)*): Map[A, B]
 bounds =
     A >: Char
     B := Boolean
 ordering =
) with Constraint(
 uninstVars = A, Boolean;
 constrained types = [A, B](elems: (A, B)*): Map[A, B]
 bounds =
     A >: String <: String
     B <: Boolean
 ordering =
)
        at dotty.tools.dotc.core.OrderingConstraint.mergeError$1(OrderingConstraint.scala:538)
        ..
        at dotty.tools.dotc.Driver.main(Driver.scala:135)
        at dotty.tools.dotc.Main.main(Main.scala)
</pre>
</dd>

<dt><b name="footnote_03">&nbsp;&nbsp;[3]&nbsp;&nbsp; <a href="https://github.com/lampepfl/dotty/issues/4356" style="font-weight:bold;">bug4356</a> 2018-04-21</i></b> <a href="#anchor_03">↩</a></dt>
<dd>
<p>
Executing <a href="bug4356/build.bat" style="font-weight:bold;font-family:Courier;">build</a> in directory <a href="bug4356/" style="font-weight:bold;font-family:Courier;">bug4356\</a> produces a runtime exception with version 0.7 of the Dotty compiler:
</p>
<pre style="font-size:80%;">
<b>&gt; build clean compile</b>
Exception in thread "main" java.nio.file.InvalidPathException: Illegal char <:> at index 72: C:\dotty\MYEXAM~1\bug4356\\lib\junit-4.12.jar:C:\dotty\MYEXAM~1\bug4356\target\dotty-0.7\classes
        at sun.nio.fs.WindowsPathParser.normalize(WindowsPathParser.java:182)
        at sun.nio.fs.WindowsPathParser.parse(WindowsPathParser.java:153)
        at sun.nio.fs.WindowsPathParser.parse(WindowsPathParser.java:77)
        at sun.nio.fs.WindowsPath.parse(WindowsPath.java:94)
        at sun.nio.fs.WindowsFileSystem.getPath(WindowsFileSystem.java:255)
        at java.nio.file.Paths.get(Paths.java:84)
        ...
        at dotty.tools.dotc.Driver.main(Driver.scala:135)
        at dotty.tools.dotc.Main.main(Main.scala)
</pre>
</dd>
</dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/October 2020* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[apache_ant_cli]: https://ant.apache.org/manual/running.html
[apache_ant_faq]: https://ant.apache.org/faq.html#ant-name
[apache_ant_history]: https://ant.apache.org/faq.html#history
[apache_ant_ivy]: https://ant.apache.org/ivy/
[apache_ant_ivy_relnotes]: https://ant.apache.org/ivy/history/2.5.0/release-notes.html
[apache_maven_cli]: https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html
[apache_maven_history]: https://maven.apache.org/docs/history.html
[bazel_cli]: https://docs.bazel.build/versions/master/command-line-reference.html
[gmake_cli]: http://www.glue.umd.edu/lsf-docs/man/gmake.html
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_groovy]: https://www.groovy-lang.org/
[gradle_java_plugin]: https://docs.gradle.org/current/userguide/java_plugin.html
[gradle_plugins]: https://docs.gradle.org/current/userguide/plugins.html
[gradle_wrapper]: https://docs.gradle.org/current/userguide/gradle_wrapper.html
[lightbend]: https://www.lightbend.com/
[microsoft_powershell]: https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6
[mill_cli]: https://www.lihaoyi.com/mill/#command-line-tools
[os_lib]: https://github.com/lihaoyi/os-lib
[sbt_cli]: https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html
[scala]: https://www.scala-lang.org/
