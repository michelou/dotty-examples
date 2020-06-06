# <span id="top">Dotty examples</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;">
    <a href="https://dotty.epfl.ch/"><img style="border:0;width:100px;" src="../docs/dotty.png" width="100" alt="Dotty logo"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>myexamples\</code></strong> contains <a href="https://dotty.epfl.ch/" alt="Dotty">Dotty</a> code examples written by myself.
  </td>
  </tr>
</table>

We can build/run each example in directory [**`myexamples\`**](.) using [**`sbt`**][sbt_cli], [**`ant`**][apache_ant_cli], [**`gradle`**][gradle_cli], [**`mill`**][mill_cli] or [**`mvn`**][apache_maven_cli] as an alternative to the **`build`** batch command.

In the following we explain in more detail the build tools available in the [**`HelloWorld`**](HelloWorld) example (and also in other examples from directory [**`myexamples\`**](./)):

<pre style="font-size:80%;">
<b>&gt; cd</b>
W:\myexamples\HelloWorld
</pre>

## <span id="build">`build.bat` command</span>

Command [**`build`**](HelloWorld/build.bat) is a basic build tool consisting of ~600 lines of batch/[Powershell ][microsoft_powershell] code <sup id="anchor_01">[[1]](#footnote_01)</sup> featuring subcommands **`clean`**, **`compile`**, **`doc`**, **`help`** and **`run`**.

Command [**`build clean run`**](HelloWorld/build.bat) produces the following output:

<pre style="font-size:80%;">
<b>&gt; <a href="HelloWorld/build.bat">build</a> clean run</b>
Hello world!
</pre>


## Gradle build tool

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

We note that [**`build.gradle`**](HelloWorld/build.gradle)<ul><li>imports the [**`java`**][gradle_java_plugin] Gradle plugin.</li><li>loads properties from file [**`gradle.properties`**](HelloWorld/gradle.properties).</li><li>imports code from parent file [**`myexamples\common.gradle`**](common.gradle).</li><li>assigns property **`scalaMainClassName`** to **`main`** and value **`""`** to **`args`** (no argument in this example) in **`run.doFirst`**.</li></ul>

The parent file [**`myexamples\common.gradle`**](common.gradle) defines the task **`compileDotty`** and manages the task dependencies.

<pre style="font-size:80%;">
<i style="color:#009900;">// overrides default "/build"</i>
buildDir file(<span style="color:#990000;">"/target"</span>)

java {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}
ext {
    ...
    classesDir = file(<span style="color:#990000;">"${buildDir}/classes"</span>)
    <b>if</b> (dottyLocal?.toBoolean()) {
        dottyHome = System.getenv(<span style="color:#990000;">"DOTTY_HOME"</span>)
        print(<span style="color:#990000;">"DOTTY_HOME=$dottyHome"</span>)
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
<b>&gt; gradle clean run</b>

&gt; Task :run
Hello world!

BUILD SUCCESSFUL in 4s
7 actionable tasks: 7 executed
</pre>


## SBT build tool

Command [**`sbt`**][sbt_cli] is a Scala-based build tool for [Scala] and Java.

The configuration file [**`build.sbt`**](HelloWorld/build.sbt) is a standalone file written in [Scala] and it obeys the [sbt build definitions](https://www.scala-sbt.org/1.0/docs/Basic-Def.html).

<pre style="font-size:80%;">
<b>val</b> dottyVersion = <span style="color:#990000;">"0.24.0-RC1"</span>
&nbsp;
<b>lazy val</b> root = project
  .in(file(<span style="color:#990000;">"."</span>))
  .settings(
    name := <span style="color:#990000;">"dotty-example-project"</span>,
    description := <span style="color:#990000;">"sbt example project to build/run Scala 3 applications"</span>,
    version := <span style="color:#990000;">"0.1.0"</span>,
    &nbsp;
    scalaVersion := dottyVersion,
    scalacOptions ++= Seq(
      <span style="color:#990000;">"-deprecation"</span>,
      <span style="color:#990000;">"-encoding"</span>, <span style="color:#990000;">"UTF-8"</span>
    ),
    &nbsp;
    libraryDependencies += <span style="color:#990000;">"com.novocode"</span> % <span style="color:#990000;">"junit-interface"</span> % <span style="color:#990000;">"0.11"</span> % <span style="color:#990000;">"test"</span>
  )
</pre>

Command **`sbt -warn clean run`** produces the following output:

<pre style="font-size:80%;">
<b>&gt; sbt -warn clean run</b>
Hello world!
</pre>


## Mill build tool

Command [**`mill`**][mill_cli] is a Scala-based build tool which aims for simplicity to build projects in a fast and predictable manner.

The configuration file [**`build.sc`**](HelloWorld/build.sc) is a standalone file written in Scala (with direct access to [OS-Lib][os_lib]).

<pre style="font-size:80%;">
<b>import</b> mill._, scalalib._
<b>import</b> $file.^.common
&nbsp;
<b>object</b> app <b>extends</b> ScalaModule {
  <b>def</b> scalaVersion = common.scalaVersion
  <b>def</b> scalacOptions = common.scalacOptions
  &nbsp;
  <b>def</b> forkArgs = common.forkArgs
  &nbsp;
  <b>def</b> mainClass = T.input {
    Some(common.getBuildProp(<span style="color:#990000;">"mainClassName"</span>, <span style="color:#990000;">"myexamples.HelloWorld"</span>, T.ctx))
  }
  &nbsp;
  <b>def</b> sources = T.sources { common.scalaSourcePath }
  <b>def</b> clean() = T.command {
    val path = os.pwd / <span style="color:#990000;">"out"</span> / <span style="color:#990000;">"app"</span>
    os.walk(path, skip = _.last == <span style="color:#990000;">"clean"</span>).foreach(os.remove.all)
  }
  <b>object</b> test <b>extends</b> Tests {
    <b>def</b> ivyDeps = Agg(
      common.ivyJunitInterface,
      common.ivyScalatest,
      common.ivySpecs2
    )
    <b>def</b> testFrameworks = Seq(
      <span style="color:#990000;">"com.novocode.junit.JUnitFramework"</span>,
      <span style="color:#990000;">"org.scalatest.tools.Framework"</span>,
      <span style="color:#990000;">"org.specs2.runner.JUnitRunner"</span> <i style="color:#009900;">// org.specs2.Specs2Framework</i>
    )
  }
}
</pre>

Command [**`mill -i app`**](HelloWorld/build.sc) produces the following output:

<pre style="font-size:80%;">
<b>&gt; mill -i app</b>
[38/38] app.run
Hello world!
</pre>


## <span id="ant">Ant build tool</span>

Command [**`ant`**][apache_ant_cli] (["Another Neat Tool"][apache_ant_faq]) is a Java-based build maintained by the [Apache Software Foundation][apache_ant_history] (tool created in 2000). It works with XML-based configuration files.

The configuration file [**`HelloWorld\build.xml`**](HelloWorld/build.xml) depends on the parent file [**`myexamples\build.xml`**](build.xml) which provides the macro definition **`dotc`** to compile the Scala source files.

<pre style="font-size:80%;">
&lt;?xml version=<span style="color:#990000;">"1.0"</span> encoding=<span style="color:#990000;">"UTF-8"</span>?&gt;
<b>&lt;project</b> name=<span style="color:#990000;">"HelloWorld"</span> default=<span style="color:#990000;">"compile"</span> basedir=<span style="color:#990000;">"."</span>&gt;
    ...
    <b>&lt;import</b> file=<span style="color:#990000;">"../build.xml"</span> />
    <b>&lt;target</b> name=<span style="color:#990000;">"compile"</span> depends=<span style="color:#990000;">"init"</span>&gt; ... <b>&lt;/target&gt;</b>
    <b>&lt;target</b> name=<span style="color:#990000;">"run"</span> depends=<span style="color:#990000;">"compile"</span>&gt; ... <b>&lt;/target&gt;</b>
    <b>&lt;target</b> name=<span style="color:#990000;">"clean"</span>&gt; ... <b>&lt;/target&gt;</b>
<b>&lt;/project&gt;</b>
</pre>

Execution of [**`HelloWorld\src\main\scala\HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output ([Ivy][apache_ant_ivy] support is enabled by default):

<pre style="font-size:80%;">
<b>&gt; ant clean run</b>
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
> <b>&gt; curl -sL -o c:\Temp\apache-ivy-2.5.0.zip https://www-eu.apache.org/dist//ant/ivy/2.5.0/apache-ivy-2.5.0-bin.zip</b>
> <b>&gt; unzip c:\temp\apache-ivy-2.5.0.zip -d c:\opt</b>
> <b>&gt; copy c:\opt\apache-ivy-2.5.0\ivy-2.5.0.jar c:\opt\apache-ant-1.10.7\lib</b>
> <b>&gt; dir c:\opt\apache-ant-1.10.7\lib | findstr ivy</b>
> 20.10.2019  09:44         1 402 646 ivy-2.5.0.jar
> </pre>

We specify property **`-Duse.local=true`** to use Dotty local installation (*reminder*: variable **`DOTTY_HOME`** is set by command **`setenv`**):

<pre style="font-size:80%;">
<b>&gt;</b> ant -Duse.local=true clean run
Buildfile: W:\myexamples\HelloWorld\build.xml

<span style="font-weight:bold;color:#9966ff;">clean:</span>
   [delete] Deleting directory W:\myexamples\HelloWorld\target

<span style="font-weight:bold;color:#9966ff;">init.local:</span>
     [echo] DOTTY_HOME=C:\opt\dotty-0.24.0-RC1

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


## Maven build tool

Command [**`mvn`**][apache_maven_cli] is a Java-based build tool maintained by the [Apache Software Foundation][apache_maven_history] (tool created in 2002). It works with XML-based configuration files and provides a way to share JARs across several projects.

The configuration file [**`HelloWorld\pom.xml`**](HelloWorld/pom.xml) depends on the parent file [**`myexamples\pom.xml`**](pom.xml) which defines common properties (eg. **`java.version`**, **`scala.version`**):

<pre style="font-size:80%;">
<b>&lt;?xml</b> version="1.0" encoding="UTF-8"?>
<b>&lt;project</b> xmlns=<span style="color:#990000;">"http://maven.apache.org/POM/4.0.0"</span> ...>
    ...
    <b>&lt;artifactId&gt;</b>HelloWorld<b>&lt;/artifactId&gt;</b>
    ...
    <b>&lt;parent&gt;</b>
        ...
        <b>&lt;relativePath&gt;</b>../pom.xml&lt;/relativePath>
    <b>&lt;/parent&gt;</b>
    <b>&lt;dependencies&gt;</b>
        <span style="color:#009900;">&lt;!-- see parent pom.xml --&gt;</span>
    <b>&lt;/dependencies&gt;</b>
    <b>&lt;build&gt;</b>
        <b>&lt;sourceDirectory&gt;</b>src/main<b>&lt;/sourceDirectory&gt;</b>
        <b>&lt;testSourceDirectory&gt;</b>src/test<b>&lt;/testSourceDirectory&gt;</b>
        <b>&lt;outputDirectory&gt;</b>target/classes<b>&lt;/outputDirectory&gt;</b>
        <b>&lt;plugins&gt;</b>
            <b>&lt;plugin&gt;</b>
                <b>&lt;groupId&gt;</b>org.apache.maven.plugins<b>&lt;/groupId&gt;</b>
                <b>&lt;artifactId&gt;</b>maven-compiler-plugin<b>&lt;/artifactId&gt;</b>
                ...
                <b>&lt;configuration&gt;</b>
                    ...
                    <b>&lt;includes&gt;</b>
                        <b>&lt;include&gt;</b>java/**/*.java<b>&lt;/include&gt;</b>
                    <b>&lt;/includes&gt;</b>
                <b>&lt;/configuration&gt;</b>
            <b>&lt;/plugin&gt;</b>
            <b>&lt;plugin&gt;</b>
                <b>&lt;groupId&gt;</b>ch.epfl.alumni<b>&lt;/groupId&gt;</b>
                <b>&lt;artifactId&gt;</b>scala-maven-plugin<b>&lt;/artifactId&gt;</b>
                ...
                <b>&lt;configuration&gt;</b>
                    <b>&lt;scalaVersion&gt;</b>${scala.version}<b>&lt;/scalaVersion&gt;</b>
                    ...
                <b>&lt;/configuration&gt;</b>
            <b>&lt;/plugin&gt;</b>
        <b>&lt;/plugins&gt;</b>
    <b>&lt;/build&gt;</b>
<b>&lt;/project&gt;</b>
</pre>

> **&#9755;** **Scala Maven Plugin**<br/>
> In the above Maven configuration file we note the presence of the Maven plugin [**`scala-maven-plugin`**](../bin/scala-maven-plugin-1.0.zip). In fact the parent file [**`examples\pom.xml`**](pom.xml) depends on [**`scala-maven-plugin`**](../bin/scala-maven-plugin-1.0.zip), a Maven plugin we developed specifically for this project:
>
> <pre style="font-size:80%;">
> <b>&gt; more ..\pom.xml</b>
> &lt;?xml version="1.0" encoding="UTF-8"?&gt;
> ...
>     <b>&lt;properties&gt;</b>
>         <b>&lt;project.build.sourceEncoding&gt;</b>UTF-8<b>&lt;/project.build.sourceEncoding&gt;</b>
>         <b>&lt;java.version&gt;</b>1.8<b>&lt;/java.version&gt;</b>
> &nbsp;
>         <i style="color:#66aa66;">&lt;!-- Scala settings --&gt;</i>
>         <b>&lt;scala.version&gt;</b>0.24.0-RC1<b>&lt;/scala.version&gt;</b>
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

Command **`mvn clean test`** with option **`-debug`** produces additional debug information, including the underlying command lines executed by our Maven plugin **`scala-maven-plugin`**:

<pre style="font-size:80%;">
<b>&gt; mvn -debug clean test | findstr /b /c:"[DEBUG]\ [execute]" 2>NUL</b>
[DEBUG] [execute] C:\opt\jdk-1.8.0_252-b09\bin\java.exe \
 -Xms64m -Xmx1024m -Dscala.home=C:\opt\dotty-0.24.0-RC1 \
 -cp C:\opt\dotty-0.24.0-RC1\lib\*.jar -Dscala.usejavacp=true  \
 dotty.tools.dotc.Main \
 -classpath W:\dotty-examples\examples\hello-scala\target\classes \
 -d W:\dotty-examples\examples\hello-scala\target\classes \
 W:\dotty-examples\examples\hello-scala\src\main\scala\hello.scala
[DEBUG] [execute] C:\opt\jdk-1.8.0_242-b08\bin\java.exe \
 -Xms64m -Xmx1024m -Dscala.home=C:\opt\dotty-0.24.0-RC1 [...]
[DEBUG] [execute] C:\opt\jdk-1.8.0_242-b08\bin\java.exe \
 -Xms64m -Xmx1024m -cp C:\opt\dotty-0.24.0-RC1\lib\*.jar;\
W:\dotty-examples\examples\hello-scala\target\classes hello
</pre>

Execution of [**`HelloWorld\src\main\scala\HelloWorld.scala`**](HelloWorld/src/main/scala/HelloWorld.scala) produces the following output (option **`--quiet`** tells Maven not to display anything other than **`ERROR`** level messages):

<pre style="font-size:80%;">
<b>&gt; mvn --quiet clean test</b>
Hello world!
</pre>

We can also specify phase **`package`** to generate (and maybe execute) the **`HelloWorld`** Java archive:

<pre style="font-size:80%;">
<b>&gt; mvn clean package</b>
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

Finally can check the Java manifest in **`HelloWorld-0.1-SNAPSHOT.jar`**:

<pre style="font-size:80%;">
<b>&gt;</b> java -Xbootclasspath/a:c:\opt\dotty-0.24.0-RC1\lib\dotty-library_0.24-0.24.0-RC1.jar;^
c:\opt\dotty-0.24.0-RC1\lib\scala-library-2.13.1.jar ^
-jar target\HelloWorld-0.1-SNAPSHOT.jar
Hello world!
</pre>

> **:mag_right:** We can use batch script [**`searchjars`**](../bin/searchjars.bat) in case some class is missing in the specified classpath, e.g.
> <pre style="font-size:80%;">
> <b>&gt; java -Xbootclasspath/a:c:\opt\dotty-0.24.0-RC1\lib\dotty-library_0.24-0.24.0-RC1.jar -jar target\enum-Color-0.1-SNAPSHOT.jar</b>
> Exception in thread "main" java.lang.NoClassDefFoundError: scala/Serializable
>         [...]
>         at Main.main(Main.scala)
> Caused by: java.lang.ClassNotFoundException: scala.Serializable
>         [...]
>         ... 13 more
> 
> <b>&gt; searchjars Serializable</b>
> Searching for class Serializable in library files C:\opt\DOTTY-~1.0-R\lib\*.jar
>   jackson-core-2.9.8.jar:com/fasterxml/jackson/core/SerializableString.class
>   [...]
>   scala-library-2.12.8.jar:scala/Serializable.class
> Searching for class Serializable in library files C:\opt\SCALA-~1.8\lib\*.jar
>   scala-library.jar:scala/Serializable.class
> Searching for class Serializable in library files C:\opt\JDK-18~1.0_2\lib\*.jar
>   tools.jar:com/sun/tools/internal/xjc/reader/xmlschema/bindinfo/BISerializable.class
> </pre>
> Class **`scala.Serializable`** is part of **`C:\opt\Dotty-0.24.0-RC1\lib\scala-library-2.13.1.jar`**, so let us add it to our classpath !


## <span id="footnotes">Footnotes</span>

<a name="footnote_01">[1]</a> ***Batch files and coding conventions*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
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
<i style="color:#66aa66;">rem ##########################################################################
rem ## Environment setup</i>

<b>set</b> _EXITCODE=0
<b>set</b> "_ROOT_DIR=<span style="color:#3333ff;">%~dp0"</span>

<b>call <span style="color:#9966ff;">:env</span></b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <b>goto <span style="color:#9966ff;">end</span></b>

<b>call <span style="color:#9966ff;">:props</span></b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <b>goto <span style="color:#9966ff;">end</span></b>

<b>call <span style="color:#9966ff;">:args</span> %*</b>
<b>if not</b> <span style="color:#3333ff;">%_EXITCODE%</span>==0 <b>goto <span style="color:#9966ff;">end</span></b>

<i style="color:#66aa66;">rem ##########################################################################
rem ## Main</i>

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

<i style="color:#66aa66;">rem ##########################################################################
rem ## Subroutines</i>

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

<i style="color:#66aa66;">rem ##########################################################################
rem ## Cleanups</i>

<span style="color:#9966ff;">:end</span>
...
<b>exit</b> /b <span style="color:#3333ff;">%_EXITCODE%</span>
</pre>

<a name="footnote_02">[2]</a> <a href="https://github.com/lampepfl/dotty/issues/4272" style="font-weight:bold;">bug4272</a> ***2018-04-08*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
Executing command <a href="bug4272/build.bat" style="font-weight:bold;font-family:Courier;">build</a> in directory <a href="bug4272/" style="font-weight:bold;font-family:Courier;">bug4272\</a> produces a runtime exception with version 0.7 of the Dotty compiler (*was fixed in version 0.8*):
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
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

<a name="footnote_03">[3]</a> <a href="https://github.com/lampepfl/dotty/issues/4356" style="font-weight:bold;">bug4356</a> ***2018-04-21*** [↩](#anchor_03)

<p style="margin:0 0 1em 20px;">
Executing <a href="bug4356/build.bat" style="font-weight:bold;font-family:Courier;">build</a> in directory <a href="bug4356/" style="font-weight:bold;font-family:Courier;">bug4356\</a> produces a runtime exception with version 0.7 of the Dotty compiler:
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
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

***

*[mics](https://lampwww.epfl.ch/~michelou/)/June 2020* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[apache_ant_cli]: https://ant.apache.org/manual/running.html
[apache_ant_faq]: https://ant.apache.org/faq.html#ant-name
[apache_ant_history]: https://ant.apache.org/faq.html#history
[apache_ant_ivy]: https://ant.apache.org/ivy/
[apache_ant_ivy_relnotes]: https://ant.apache.org/ivy/history/2.5.0/release-notes.html
[apache_maven_cli]: https://maven.apache.org/ref/3.6.3/maven-embedder/cli.html
[apache_maven_history]: https://maven.apache.org/docs/history.html
[gradle_cli]: https://docs.gradle.org/current/userguide/command_line_interface.html
[gradle_groovy]: https://www.groovy-lang.org/
[gradle_java_plugin]: https://docs.gradle.org/current/userguide/java_plugin.html
[gradle_plugins]: https://docs.gradle.org/current/userguide/plugins.html
[gradle_wrapper]: https://docs.gradle.org/current/userguide/gradle_wrapper.html
[microsoft_powershell]: https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6
[mill_cli]: https://www.lihaoyi.com/mill/#command-line-tools
[os_lib]: https://github.com/lihaoyi/os-lib
[sbt_cli]: https://www.scala-sbt.org/1.x/docs/Command-Line-Reference.html
[scala]: https://www.scala-lang.org/
