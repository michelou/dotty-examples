# <span id="top">Dotty examples</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>myexamples\</code></strong> contains <a href="http://dotty.epfl.ch/" alt="Dotty">Dotty</a> code examples written by myself.
  </td>
  </tr>
</table>


We can build/run each example in directory [**`myexamples\`**](.) using [**`sbt`**](https://www.scala-sbt.org/), [**`ant`**](https://ant.apache.org/manual/running.html), [**`gradle`**](https://docs.gradle.org/current/userguide/command_line_interface.html), [**`mill`**](http://www.lihaoyi.com/mill/#command-line-tools) or [**`mvn`**](http://maven.apache.org/ref/3.6.0/maven-embedder/cli.html) as an alternative to the **`build`** batch command.

In the following we explain in more detail the build tools available in the [**`HelloWorld`**](HelloWorld) example (and also in other examples from directory [**`myexamples\`**](./)):

## Command `build`

Command [**`build`**](dotty-example-project/build.bat) is a basic build tool consisting of ~400 lines of batch/[Powershell ](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) code featuring subcommands **`clean`**, **`compile`**, **`doc`**, **`help`** and **`run`**.

The batch file for command [**`build`**](HelloWorld/build.bat) obeys the following coding conventions:

- The file is organized in 4 sections: `Environment setup`, `Main`, `Subroutines` and `Cleanups`.
- The file contains exactly ***one exit instruction*** (label **`end`** in section **`Cleanups`**).
- Names of global variables start with the `_` character (shell variables defined in the user environment start with a letter).
- Names of local variables (e.g. inside subroutines or  **`if/for`** constructs) start with `__` (two `_` characters).

<pre style="font-size:80%;">
@echo off
setlocal enabledelayedexpansion
...
rem ##########################################################################
rem ## Environment setup

set _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

call :props
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

rem ##########################################################################
rem ## Main

if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    call :compile
    if not !_EXITCODE!==0 goto end
)
if %_DOC%==1 (
    call :doc
    if not !_EXITCODE!==0 goto end
)
if %_RUN%==1 (
    call :run
    if not !_EXITCODE!==0 goto end
)
goto end

rem ##########################################################################
rem ## Subroutines

:props
...
goto :eof
:args
...
goto :eof
:clean
...
goto :eof
:compile
...
goto :eof
:doc
...
goto :eof
:run
...
goto :eof
:end

rem ##########################################################################
rem ## Cleanups

:end
...
exit /b %_EXITCODE%
</pre>

Execution of [**`HelloWorld\src\main\scala\HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output:

<pre style="font-size:80%;">
&gt; build clean run
Hello world!
</pre>


## Command `gradle`

Command [**`gradle`**](http://www.gradle.org/) is the official build tool for Android applications (tool created in 2007). It replaces XML-based build scripts with a [Groovy](http://www.groovy-lang.org/)-based DSL.

> **&#9755;** ***Gradle Wrappers***<br/>
> We don't rely on them even if using [Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html) is the  recommended way to execute a Gradle build.<br/>
> Simply execute the **`gradle wrapper`** command to generate the wrapper files; you can then run **`gradlew`** instead of [**`gradle`**](https://docs.gradle.org/current/userguide/command_line_interface.html).

The configuration file [**`build.gradle`**](HelloWorld/build.gradle) for [**`HelloWorld\`**](HelloWorld/) looks as follows:

<pre style="font-size:80%;">
apply plugin: 'java'
apply plugin: 'application'
apply from: '../common.gradle'
&nbsp;
group = 'dotty.examples'
version = '0.1-SNAPSHOT'
&nbsp;
description = """Example Gradle project that compiles using Dotty"""
&nbsp;
mainClassName = 'Main'
&nbsp;
run.doFirst {
    main mainClassName
    args ''
}
</pre>

We note that [**`build.gradle`**](HelloWorld/build.gradle)<ul><li>imports the two [Gradle plugins](https://docs.gradle.org/current/userguide/plugins.html): [**`java`**](https://docs.gradle.org/current/userguide/java_plugin.html) and [**`application`**](https://docs.gradle.org/current/userguide/application_plugin.html#header)</li><li>imports code from the parent file [**`common.gradle`**](common.gradle)</li><li>assigns property **`mainClassName`** to **`main`** and value **`''`** to **`args`** (no argument in this case) in **`run.doFirst`**</li></ul>

The parent file [**`common.gradle`**](common.gradle) defines the task **`compileDotty`** and manages the task dependencies.

<pre style="font-size:80%;">
sourceCompatibility = 1.8
targetCompatibility = 1.8
&nbsp;
ext {
    dottyLibraryPath = file(System.getenv("DOTTY_HOME") + "/lib")
    ...
    targetDir = file("/target")
}
clean.doLast {
    targetDir.deleteDir()
}
task compileDotty(type: JavaExec) {
    dependsOn compileJava
    ...
    main "dotty.tools.dotc.Main"
}
compileDotty.doFirst {
    if (!classesDir.exists()) classesDir.mkdirs()
}
build {
    dependsOn compileDotty
}
run {
    dependsOn build
    ...
    main mainClassName
}
...
</pre>

Execution of [**`HelloWorld\src\main\scala\HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output:

<pre style="font-size:80%;">
&gt; gradle clean run

&gt; Task :run
Hello world!

BUILD SUCCESSFUL in 4s
7 actionable tasks: 7 executed
</pre>


## Command `sbt`

Command [**`sbt`**](https://www.scala-sbt.org/) is a Scala-based build tool for [**`Scala`**](https://www.scala-lang.org/) and Java.

The configuration file [**`build.sbt`**](HelloWorld/build.sbt) is a standalone file written in [Scala](https://www.scala-lang.org/) and it obeys the [sbt build definitions](https://www.scala-sbt.org/1.0/docs/Basic-Def.html).

<pre style="font-size:80%;">
val dottyVersion = "0.12.0-RC1"
&nbsp;
lazy val root = project
  .in(file("."))
  .settings(
    name := "dotty-example-project",
    description := "Example sbt project that compiles using Dotty",
    version := "0.1.0",
    &nbsp;
    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      "-deprecation"
    )
  )
</pre>

Execution of [**`HelloWorld\src\main\scala\HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output:

<pre style="font-size:80%;">
&gt; sbt -warn clean run
Hello world!
</pre>


## Command `mill`

Command [**`mill`**](http://www.lihaoyi.com/mill/#command-line-tools) is a Scala-based build tool which aims for simplicity to build projects in a fast and predictable manner.

The configuration file [**`build.sc`**](HelloWorld/build.sc) is a standalone file written in Scala (with direct access to [OS-Lib](https://github.com/lihaoyi/os-lib)).

<pre style="font-size:80%;">
import mill._, scalalib._
&nbsp;
object go extends ScalaModule {
  def scalaVersion = "0.12.0-RC1"  // "2.12.18"
  def scalacOptions = Seq("-deprecation", "-feature")
  def forkArgs = Seq("-Xmx1g")
  def mainClass = Some("Main")
  def sources = T.sources { os.pwd / "src" }
  def clean() = T.command {
    val path = os.pwd / "out" / "go"
    os.walk(path, skip = _.last == "clean").foreach(os.remove.all)
  }
}
</pre>

Execution of [**`HelloWorld\src\main\scala\HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output:

<pre style="font-size:80%;">
&gt; mill -i go
[38/38] go.run
Hello world!
</pre>


## Command `ant`

Command [**`ant`**](https://ant.apache.org/) (["Another Neat Tool"](https://ant.apache.org/faq.html#ant-name)) is a Java-based build maintained by the [Apache Software Foundation](https://ant.apache.org/faq.html#history) (tool created in 2000). It works with XML-based configuration files.

The configuration file [**`build.xml`**](HelloWorld/build.xml) in directory [**`HelloWorld\`**](HelloWorld/) depends on the parent file [**`build.xml`**](myexamples/build.xml) which provides the macro definition **`dotc`** to execute the external batch command **`dotc.bat`** (**WIP** : [Ivy](http://ant.apache.org/ivy/) support).

<pre style="font-size:80%;">
&lt;?xml version="1.0" encoding="UTF-8"?>
&lt;project name="dotty-example-project" default="compile" basedir=".">
    ...
    &lt;import file="../build.xml" />
    &lt;target name="compile" depends="init"> ... &lt;/target>
    &lt;target name="run" depends="compile"> ... &lt;/target>
    &lt;target name="clean"> ... &lt;/target>
&lt;/project>
</pre>

Execution of [**`HelloWorld\src\main\scala\HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output:

<pre style="font-size:80%;">
&gt; ant clean run
Buildfile: W:\dotty-examples\myexamples\HelloWorld\build.xml

clean:
   [delete] Deleting directory W:\dotty-examples\myexamples\HelloWorld\target

init:

compile:
    [mkdir] Created dir: W:\dotty-examples\myexamples\HelloWorld\target\classes
   [scalac] Compiling 1 source file to W:\dotty-examples\myexamples\HelloWorld/target/classes

run:
     [java] Hello world!

BUILD SUCCESSFUL
Total time: 3 seconds
</pre>


## Command `mvn`

Command [**`mvn`**](http://maven.apache.org/ref/3.6.0/maven-embedder/cli.html) is a Java-based build tool maintained by the [Apache Software Foundation](https://maven.apache.org/docs/history.html) (tool created in 2002). It works with XML-based configuration files and provides a way to share JARs across several projects.

The configuration file [**`pom.xml`**](HelloWorld/pom.xml) in directory [**`HelloWorld\`**](HelloWorld/) depends on the parent file [**`pom.xml`**](pom.xml) which defines common properties (eg. **`java.version`**, **`scala.version`**):

<pre style="font-size:80%;">
&lt;?xml version="1.0" encoding="UTF-8"?>
&lt;project xmlns="http://maven.apache.org/POM/4.0.0" ...>
    ...
    &lt;artifactId>HelloWorld&lt;/artifactId>
    ...
    &lt;parent>
        ...
        &lt;relativePath>../pom.xml&lt;/relativePath>
    &lt;/parent>
    &lt;dependencies>
        &lt;!-- see parent pom.xml -->
    &lt;/dependencies>
    &lt;build>
        &lt;sourceDirectory>src/main&lt;/sourceDirectory>
        &lt;testSourceDirectory>src/test&lt;/testSourceDirectory>
        &lt;outputDirectory>target/classes&lt;/outputDirectory>
        &lt;plugins>
            &lt;plugin>
                &lt;groupId>org.apache.maven.plugins&lt;/groupId>
                &lt;artifactId>maven-compiler-plugin&lt;/artifactId>
                ...
                &lt;configuration>
                    ...
                    &lt;includes>
                        &lt;include>java/**/*.java&lt;/include>
                    &lt;/includes>
                &lt;/configuration>
            &lt;/plugin>
            &lt;plugin>
                &lt;groupId>ch.epfl.alumni&lt;/groupId>
                &lt;artifactId>scala-maven-plugin&lt;/artifactId>
                ...
                &lt;configuration>
                    &lt;scalaVersion>${scala.version}&lt;/scalaVersion>
                    ...
                &lt;/configuration>
            &lt;/plugin>
        &lt;/plugins>
    &lt;/build>
&lt;/project>
</pre>

Running command **` mvn compile test`** with option **`-debug`** produces additional debug information, including the underlying command lines executed by our Maven plugin **`scala-maven-plugin`**:

<pre>
&gt; mvn -debug compile test | findstr /b /c:"[DEBUG]\ [execute]" 2>NUL
[DEBUG] [execute] C:\Progra~1\Java\jdk1.8.0_201\bin\java.exe \
 -Xms64m -Xmx1024m -Dscala.home=C:\opt\dotty-0.12.0-RC1 \
 -cp C:\opt\dotty-0.12.0-RC1\lib\*.jar -Dscala.usejavacp=true  \
 dotty.tools.dotc.Main \
 -classpath W:\dotty-examples\examples\hello-scala\target\classes \
 -d W:\dotty-examples\examples\hello-scala\target\classes \
 W:\dotty-examples\examples\hello-scala\src\main\scala\hello.scala
[DEBUG] [execute] C:\Progra~1\Java\jdk1.8.0_201\bin\java.exe \
 -Xms64m -Xmx1024m -Dscala.home=C:\opt\dotty-0.12.0-RC1 [...]
[DEBUG] [execute] C:\Progra~1\Java\jdk1.8.0_201\bin\java.exe \
 -Xms64m -Xmx1024m -cp C:\opt\dotty-0.12.0-RC1\lib\*.jar;\
W:\dotty-examples\examples\hello-scala\target\classes hello
</pre>

Execution of [**`HelloWorld\src\main\scala\HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output:

<pre style="font-size:80%;">
&gt; mvn --quiet clean test
Hello world!
</pre>


## Footnotes

<a name="footnote_01">[1]</a> <a href="https://github.com/lampepfl/dotty/issues/4272" style="font-weight:bold;">bug4272</a> ***2018-04-08*** [↩](#anchor_01)

<div style="margin:0 0 1em 20px;">
Executing command <a href="bug4272/build.bat" style="font-weight:bold;font-family:Courier;">build</a> in directory <a href="bug4272/" style="font-weight:bold;font-family:Courier;">bug4272\</a> produces a runtime exception with version 0.7 of the Dotty compiler (*was fixed in version 0.8*):

<pre style="font-size:80%;">
> build clean compile run
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
</div>

<a name="footnote_02">[2]</a> <a href="https://github.com/lampepfl/dotty/issues/4356" style="font-weight:bold;">bug4356</a> ***2018-04-21*** [↩](#anchor_02)

<div style="margin:0 0 1em 20px;">
Executing <a href="bug4356/build.bat" style="font-weight:bold;font-family:Courier;">build</a> in directory <a href="bug4356/" style="font-weight:bold;font-family:Courier;">bug4272\</a> produces a runtime exception with version 0.7 of the Dotty compiler:

<pre>
> build clean compile
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
</div>


*[mics](http://lampwww.epfl.ch/~michelou/)/January 2019* [**&#9650;**](#top)
