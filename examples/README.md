# <span id="top">Dotty examples</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>examples\</code></strong> contains <a href="http://dotty.epfl.ch/" alt="Dotty">Dotty</a> examples coming from various websites - mostly from the <a href="http://dotty.epfl.ch/">Dotty project</a>.
  </td>
  </tr>
</table>

We can build/run each example in directory [**`examples\`**](.) using [**`sbt`**](https://www.scala-sbt.org/), [**`ant`**](https://ant.apache.org/manual/running.html), [**`gradle`**](https://docs.gradle.org/current/userguide/command_line_interface.html), [**`mill`**](http://www.lihaoyi.com/mill/#command-line-tools) or [**`mvn`**](http://maven.apache.org/ref/3.6.0/maven-embedder/cli.html) as an alternative to the **`build`** batch command.

In the following we explain in more detail the build tools available in the [**`enum-Planet\`**](enum-Planet/) example (and also in other examples from directory [**`examples\`**](./)):

## Command `build`

Command [**`build`**](enum-Planet/build.bat) is a basic build tool consisting of ~400 lines of batch/[Powershell ](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) code featuring subcommands **`clean`**, **`compile`**, **`doc`**, **`help`** and **`run`**.

> **:mag_right:** The batch file for command [**`build`**](enum-Planet/build.bat) obeys the following coding conventions:
>
> - We use at most 80 characters per line. In general we would say that 80 characters fit well with 4:3 screens and 100 characters fit well with 16:9 screens ([Google's convention](https://google.github.io/styleguide/javaguide.html#s4.4-column-limit) is 100 characters).
> - We organize our code in 4 sections: `Environment setup`, `Main`, `Subroutines` and `Cleanups`.
> - We write exactly ***one exit instruction*** (label **`end`** in section **`Cleanups`**).
> - We start names of global variables with the `_` character (shell variables defined in the user environment start with a letter).
> - We start names of local variables (e.g. inside subroutines or  **`if/for`** constructs) start with `__` (two `_` characters).

<pre style="font-size:80%;">
@echo off
<b>setlocal enabledelayedexpansion</b>
...
<span style="color:#006600;">rem ##########################################################################
rem ## Environment setup</span>

<b>set</b> _EXITCODE=0

for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf

<b>call <span style="color:#9966ff;">:props</span></b>
if not %_EXITCODE%==0 goto end

<b>call <span style="color:#9966ff;">:args</span> %*</b>
if not %_EXITCODE%==0 goto end

<span style="color:#006600;">rem ##########################################################################
rem ## Main</span>

if %_CLEAN%==1 (
    call :clean
    if not !_EXITCODE!==0 goto end
)
if %_COMPILE%==1 (
    <b>call <span style="color:#9966ff;">:compile</span></b>
    if not !_EXITCODE!==0 goto end
)
if %_DOC%==1 (
    <b>call <span style="color:#9966ff;">:doc</span></b>
    if not !_EXITCODE!==0 goto end
)
if %_RUN%==1 (
    <b>call <span style="color:#9966ff;">:run</span></b>
    if not !_EXITCODE!==0 goto end
)
<b>goto <span style="color:#9966ff;">end</span></b>

<span style="color:#006600;">rem ##########################################################################
rem ## Subroutines</span>

<span style="color:#9966ff;">:props</span>
...
<b>goto :eof</b>
<span style="color:#9966ff;">:args</span>
...
<b>goto :eof</b>
<span style="color:#9966ff;">:clean</span>
...
goto :eof
<span style="color:#9966ff;">:compile</span>
...
goto :eof
<span style="color:#9966ff;">:doc</span>
...
<b>goto :eof</b>
<span style="color:#9966ff;">:run</span>
...
<b>goto :eof</b>

<span style="color:#006600;">rem ##########################################################################
rem ## Cleanups</span>

<span style="color:#9966ff;">:end</span>
...
<b>exit</b> /b %_EXITCODE%
</pre>

Execution of [**`enum-Planet\src\main\scala\Planet.scala`**](enum-Planet/src/main/scala/Planet.scala) produces the following output:

<pre style="font-size:80%;">
&gt; build clean run
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
</pre>


Running command [**`build`**](enum-Planet/build.bat) with option **`-verbose`** in project [**`enum-Planet\`**](enum-Planet/) displays progress messages:

<pre style="font-size:80%;">
&gt; build -verbose clean compile run
Compile Scala sources to target\classes
Execute Scala main class Planet
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
</pre>

Finally, running command [**`build`**](enum-Planet/build.bat) with option **`-debug`** in project [**`enum-Planet`**](enum-Planet/) also displays internal steps of the build process:

<pre style="font-size:80%;">
<b/>&gt;</b> build -debug clean compile run
[build] _CLEAN=1 _COMPILE=1 _COMPILE_CMD=dotc _RUN=1
[build] del /s /q W:\dotty\examples\ENUM-P~1\target\classes\*.class W:\dotty\examples\ENUM-P~1\target\classes\*.hasTasty W:\dotty\examples\ENUM-P~1\target\classes\.latest-build
[build] 20180322224754 W:\dotty\examples\ENUM-P~1\src\main\scala\Planet.scala
[build] 00000000000000 W:\dotty\examples\ENUM-P~1\target\classes\.latest-build
[build] dotc  -classpath W:\dotty\examples\ENUM-P~1\target\classes -d C:\dotty\examples\ENUM-P~1\target\classes  W:\dotty\examples\ENUM-P~1\src\main\scala\Planet.scala
[build] dot -classpath W:\dotty\examples\ENUM-P~1\target\classes Planet 1
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
[build] _EXITCODE=0</pre>

Compilation of the Java/Scala source files is performed only if needed during the build process:

<pre style="font-size:80%;">
> build clean

> build compile

> build compile
No compilation needed (1 source files)</pre>

> **:mag_right:** The above `enum-Planet` example expects 1 argument at execution time.<br/>
> For simplicity the [**`build`**](enum-Planet/build.bat) command currently relies on the property `main.args` defined in file [**`project\build.properties`**](enum-Planet/project/build.properties) (part of the SBT configuration) to specify program arguments.<br/>
> <pre style="font-size:80%;">
> <b>&gt;</b> type project\build.properties
> sbt.version=1.2.8
> main.class=Planet
> main.args=1
> </pre>
> With SBT you have to run the example as follows:<br/>
> <pre style="font-size:80%;">
> > sbt clean compile "run 1"
> > sbt "run 1"
> </pre>
> 

## Gradle build tool

Command [**`gradle`**](http://www.gradle.org/) is the official build tool for Android applications (tool created in 2007). It replaces XML-based build scripts with a [Groovy](http://www.groovy-lang.org/)-based DSL.

> **&#9755;** ***Gradle Wrappers***<br/>
> We don't rely on them even if using [Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html) is the  recommended way to execute a Gradle build.<br/>
> Simply execute the **`gradle wrapper`** command to generate the wrapper files; you can then run **`gradlew`** instead of [**`gradle`**](https://docs.gradle.org/current/userguide/command_line_interface.html).

The configuration file [**`build.gradle`**](enum-Planet/build.gradle) for [**`enum-Planet\`**](enum-Planet/) looks as follows:

<pre style="font-size:80%;">
apply plugin: <span style="color:#990000;">'java'</span>
apply plugin: <span style="color:#990000;">'application'</span>
apply from: <span style="color:#990000;">'../common.gradle'</span>
&nbsp;
group = <span style="color:#990000;">'dotty.examples'</span>
version = <span style="color:#990000;">'0.1-SNAPSHOT'</span>
&nbsp;
description = <span style="color:#990000;">"""Example Gradle project that compiles using Dotty"""</span>
&nbsp;
mainClassName = <span style="color:#990000;">'Planet'</span>
&nbsp;
run.doFirst {
    main mainClassName
    args ''
}
</pre>

We note that [**`build.gradle`**](enum-Planet/build.gradle)<ul><li>imports the two [Gradle plugins](https://docs.gradle.org/current/userguide/plugins.html): [**`java`**](https://docs.gradle.org/current/userguide/java_plugin.html) and [**`application`**](https://docs.gradle.org/current/userguide/application_plugin.html#header)</li><li>imports code from the parent file [**`common.gradle`**](common.gradle)</li><li>assigns property **`mainClassName`** to **`main`** and value **`''`** to **`args`** (no argument in this case) in **`run.doFirst`**</li></ul>

The parent file [**`common.gradle`**](common.gradle) defines the task **`compileDotty`** and manages the task dependencies.

<pre style="font-size:80%;">
sourceCompatibility = 1.8
targetCompatibility = 1.8
&nbsp;
ext {
    dottyLibraryPath = file(System.getenv(<span style="color:#990000;">"DOTTY_HOME"</span>) + <span style="color:#990000;">"/lib"</span>)
    ...
    targetDir = file(<span style="color:#990000;">"/target"</span>)
}
clean.doLast {
    targetDir.deleteDir()
}
task compileDotty(type: JavaExec) {
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
run {
    dependsOn build
    ...
    main mainClassName
}
...
</pre>

Execution of [**`enum-Planet\src\main\scala\Planet.scala`**](enum-Planet/src/main/scala/Planet.scala) produces the following output:

<pre style="font-size:80%;">
<b>&gt;</b> gradle clean run

> Task :run
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406

BUILD SUCCESSFUL in 4s
7 actionable tasks: 7 executed
</pre>


## SBT build tool

Command [**`sbt`**](https://www.scala-sbt.org/) is a Scala-based build tool for [**`Scala`**](https://www.scala-lang.org/) and Java.

The configuration file [**`build.sbt`**](enum-Planet/build.sbt) is a standalone file written in [Scala](https://www.scala-lang.org/) and it obeys the [sbt build definitions](https://www.scala-sbt.org/1.0/docs/Basic-Def.html).

<pre style="font-size:80%;">
<b>val</b> dottyVersion = <span style="color:#990000;">"0.12.0-RC1"</span>
&nbsp;
<b>lazy val</b> root = project
  .in(file("."))
  .settings(
    name := <span style="color:#990000;">"enum-Planet"</span>,
    description := <span style="color:#990000;">"Example sbt project that compiles using Dotty"</span>,
    version := <span style="color:#990000;">"0.1.0"</span>,
    &nbsp;
    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      <span style="color:#990000;">"-deprecation"</span>
    )
  )
</pre>


Execution of [**`enum-Planet\src\main\scala\Planet.scala`**](enum-Planet/src/main/scala/Planet.scala) expects one argument and produces the following output:

<pre style="font-size:80%;">
&gt; sbt -warn clean "run 1"
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
</pre>


## Mill build tool

Command [**`mill`**](http://www.lihaoyi.com/mill/#command-line-tools) is a Scala-based build tool which aims for simplicity to build projects in a fast and predictable manner.

The configuration file [**`build.sc`**](enum-Planet/build.sc) is a standalone file written in Scala (with direct access to [OS-Lib](https://github.com/lihaoyi/os-lib)).

<pre style="font-size:80%;">
<b>import</b> mill._, scalalib._
&nbsp;
<b>object</b> go <b>extends</b> ScalaModule {
  <b>def</b> scalaVersion = <span style="color:#990000;">"0.12.0-RC1"</span>  // "2.12.18"
  <b>def</b> scalacOptions = Seq(<span style="color:#990000;">"-deprecation"</span>, <span style="color:#990000;">"-feature"</span>)
  <b>def</b> forkArgs = Seq(<span style="color:#990000;">"-Xmx1g"</span>)
  <b>def</b> mainClass = Some(<span style="color:#990000;">"Planet"</span>)
  <b>def</b> sources = T.sources { os.pwd / <span style="color:#990000;">"src"</span> }
  <b>def</b> clean() = T.command {
    val path = os.pwd / <span style="color:#990000;">"out"</span> / <span style="color:#990000;">"go"</span>
    os.walk(path, skip = _.last == <span style="color:#990000;">"clean"</span>).foreach(os.remove.all)
  }
}
</pre>

Execution of [**`enum-Planet\src\main\scala\Planet.scala`**](enum-Planet/src/main/scala/Planet.scala) produces the following output:

<pre style="font-size:80%;">
<b>&gt;</b> mill -i go.run 1
[38/38] go.run
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
</pre>


## Ant build tool

Command [**`ant`**](https://ant.apache.org/) (["Another Neat Tool"](https://ant.apache.org/faq.html#ant-name)) is a Java-based build tool maintained by the [Apache Software Foundation](https://ant.apache.org/faq.html#history) (tool created in 2000). It works with XML-based configuration files.

The configuration file [**`build.xml`**](enum-Planet/build.xml) in directory [**`enum-Planet\`**](enum-Planet/) depends on the parent file [**`build.xml`**](build.xml) which provides the macro definition **`dotc`** to compile the Scala source files.

<pre style="font-size:80%;">
&lt;?xml version="1.0" encoding="UTF-8"?>
<b>&lt;project</b> name=<span style="color:#990000;">"enum-Planet"</span> default=<span style="color:#990000;">"compile"</span> basedir=<span style="color:#990000;">"."</span>&gt;
    ...
    <b>&lt;import</b> file=<span style="color:#990000;">"../build.xml"</span> /&gt;
    <b>&lt;target</b> name=<span style="color:#990000;">"compile"</span> depends="init"> ... <b>&lt;/target&gt;</b>
    <b>&lt;target</b> name=<span style="color:#990000;">"run"</span> depends=<span style="color:#990000;">"compile"</span>&gt; ... <b>&lt;/target&gt;</b>
    <b>&lt;target</b> name=<span style="color:#990000;">"clean"</span>&gt; ... <b>&lt;/target&gt;</b>
<b>&lt;/project&gt;</b>
</pre>

Execution of [**`enum-Planet\src\main\scala\Planet.scala`**](enum-Planet/src/main/scala/Planet.scala) produces the following output ([Ivy](http://ant.apache.org/ivy/) support is enabled by default):

<pre style="font-size:80%;">
<b>&gt;</b> ant clean run
Buildfile: W:\dotty-examples\examples\enum-Planet\build.xml

<span style="font-weight:bold;color:#9966ff;">clean:</span>
   [delete] Deleting directory W:\dotty-examples\examples\enum-Planet\target

<span style="font-weight:bold;color:#9966ff;">init.local:</span>

<span style="font-weight:bold;color:#9966ff;">init.ivy:</span>
[ivy:resolve] :: Apache Ivy 2.5.0-rc1 - 20180412005306 :: http://ant.apache.org/ivy/ ::
[ivy:resolve] :: loading settings :: url = jar:file:/C:/opt/apache-ant-1.10.5/lib/ivy-2.5.0-rc1.jar!/org/apache/ivy/core/settings/ivysettings.xml

<span style="font-weight:bold;color:#9966ff;">init:</span>

<span style="font-weight:bold;color:#9966ff;">compile:</span>
    [mkdir] Created dir: W:\dotty-examples\examples\enum-Planet\target\classes
   [scalac] Compiling 1 source file to W:\dotty-examples\examples\enum-Planet/target/classes

<span style="font-weight:bold;color:#9966ff;">run:</span>
     [java] Your weight on MERCURY is 0.37775761520093526
     [java] Your weight on SATURN is 1.0660155388115666
     [java] Your weight on VENUS is 0.9049990998410455
     [java] Your weight on URANUS is 0.9051271993894251
     [java] Your weight on EARTH is 0.9999999999999999
     [java] Your weight on NEPTUNE is 1.1383280724696578
     [java] Your weight on MARS is 0.37873718403712886
     [java] Your weight on JUPITER is 2.5305575254957406

BUILD SUCCESSFUL
Total time: 19 seconds
</pre>

> **&#9755;** ***Apache Ivy***<br/>
> The [Ivy](http://ant.apache.org/ivy/) Java archive must be added to the [Ant](https://ant.apache.org/) installation directory as displayed by task **`init.ivy`** in the above output. In our case we work with [version 2.5.0-rc1](http://ant.apache.org/ivy/history/2.5.0-rc1/release-notes.html) of the Apache Ivy library.
> <pre style="font-size:80%;">
> <b>&gt;</b> dir /b c:\opt\apache-ant-1.10.5\lib\ivy*
> ivy-2.5.0-rc1.jar
> </pre>

We specify property **`-Duse.local=true`** to use Dotty local installation (*reminder*: variable **`DOTTY_HOME`** is set by command **`setenv`**):

<pre style="font-size:80%;">
<b>&gt;</b> ant -Duse.local=true clean run
Buildfile: W:\dotty-examples\examples\enum-Planet\build.xml

<span style="font-weight:bold;color:#9966ff;">clean:</span>
   [delete] Deleting directory W:\dotty-examples\examples\enum-Planet\target

<span style="font-weight:bold;color:#9966ff;">init.local:</span>
     [echo] DOTTY_HOME=C:\opt\dotty-0.12.0-RC1

<span style="font-weight:bold;color:#9966ff;">init.ivy:</span>

<span style="font-weight:bold;color:#9966ff;">init:</span>

<span style="font-weight:bold;color:#9966ff;">compile:</span>
    [mkdir] Created dir: W:\dotty-examples\examples\enum-Planet\target\classes
   [scalac] Compiling 1 source file to W:\dotty-examples\examples\enum-Planet/target/classes

<span style="font-weight:bold;color:#9966ff;">run:</span>
     [java] Your weight on MERCURY is 0.37775761520093526
     [java] Your weight on SATURN is 1.0660155388115666
     [java] Your weight on VENUS is 0.9049990998410455
     [java] Your weight on URANUS is 0.9051271993894251
     [java] Your weight on EARTH is 0.9999999999999999
     [java] Your weight on NEPTUNE is 1.1383280724696578
     [java] Your weight on MARS is 0.37873718403712886
     [java] Your weight on JUPITER is 2.5305575254957406

BUILD SUCCESSFUL
Total time: 14 seconds
</pre>


## Maven build tool

Command [**`mvn`**](http://maven.apache.org/ref/3.6.0/maven-embedder/cli.html) is a Java-based build tool maintained by the [Apache Software Foundation](https://maven.apache.org/docs/history.html) (tool created in 2002). It works with XML-based configuration files and provides a way to share JARs across several projects.

The configuration file [**`pom.xml`**](enum-Planet/pom.xml) in directory [**`enum-Planet\`**](enum-Planet/) depends on the parent file [**`pom.xml`**](pom.xml) which defines common properties (eg. **`java.version`**, **`scala.version`**):

<pre style="font-size:80%;">
&lt;?xml version="1.0" encoding="UTF-8"?>
<b>&lt;project</b> xmlns=<span style="color:#990000;">"http://maven.apache.org/POM/4.0.0"</span> ...&gt;
    ...
    <b>&lt;artifactId&gt;</b>enum-Planet<b>&lt;/artifactId&gt;</b>
    ...
    <b>&lt;parent&gt;</b>
        ...
        &lt;relativePath>../pom.xml&lt;/relativePath>
    <b>&lt;/parent&gt;</b>
    <b>&lt;dependencies&gt;</b>
        &lt;!-- see parent pom.xml -->
    <b>&lt;/dependencies&gt;</b>
    <b>&lt;build&gt;</b>
        &lt;sourceDirectory>src/main&lt;/sourceDirectory>
        &lt;testSourceDirectory>src/test&lt;/testSourceDirectory>
        &lt;outputDirectory>target/classes&lt;/outputDirectory>
        <b>&lt;plugins&gt;</b>
            <b>&lt;plugin&gt;</b>
                &lt;groupId>org.apache.maven.plugins&lt;/groupId>
                &lt;artifactId>maven-compiler-plugin&lt;/artifactId>
                ...
                <b>&lt;configuration&gt;</b>
                    ...
                    &lt;includes>
                        &lt;include>java/**/*.java&lt;/include>
                    &lt;/includes>
                <b>&lt;/configuration&gt;</b>
            <b>&lt;/plugin&gt;</b>
            <b>&lt;plugin&gt;</b>
                &lt;groupId>ch.epfl.alumni&lt;/groupId>
                &lt;artifactId>scala-maven-plugin&lt;/artifactId>
                ...
                &lt;configuration>
                    &lt;scalaVersion>${scala.version}&lt;/scalaVersion>
                    ...
                &lt;/configuration>
            <b>&lt;/plugin&gt;</b>
        <b>&lt;/plugins&gt;</b>
    <b>&lt;/build&gt;</b>
<b>&lt;/project&gt;</b>
</pre>

Running command **` mvn compile test`** with option **`-debug`** produces additional debug information, including the underlying command lines executed by our Maven plugin **`scala-maven-plugin`**:

<pre>
&gt; mvn -debug compile test | findstr /b /c:"[DEBUG]\ [execute]" 2>NUL
[DEBUG] [execute] C:\Progra~1\Java\jdk1.8.0_201\bin\java.exe \
 -Xms64m -Xmx1024m -Dscala.home=C:\opt\dotty-0.12.0-RC1 \
 -cp C:\opt\dotty-0.11.0-RC1\lib\*.jar -Dscala.usejavacp=true  \
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

Execution of [**`enum-Planet\src\main\scala\Planet.scala`**](enum-Planet/src/main/scala/Planet.scala) produces the following output:

<pre style="font-size:80%;">
<b>&gt;</b> mvn --quiet clean test
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
</pre>


*[mics](http://lampwww.epfl.ch/~michelou/)/January 2019* [**&#9650;**](#top)






