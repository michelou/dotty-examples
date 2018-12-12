# Dotty examples

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

Each example in directory **`examples\`** can also be built using [**`sbt`**](https://www.scala-sbt.org/), [**`ant`**](https://ant.apache.org/manual/running.html), [**`gradle`**](https://docs.gradle.org/current/userguide/command_line_interface.html), [**`mill`**](http://www.lihaoyi.com/mill/#command-line-tools) or [**`mvn`**](http://maven.apache.org/ref/3.6.0/maven-embedder/cli.html) as an alternative to the **`build`** batch command.

## Build tools

In this section we explain in more detail the available build tools available in the [**`examples\dotty-example-project`**](dotty-example-project/) example (and also in other examples from directory **`examples\`**):

1. [**`build.bat`**](dotty-example-project/build.bat) - This batch command is a basic build tool consisting of ~350 lines of batch/[Powershell ](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) code.
    <pre>
    @echo off
    setlocal enabledelayedexpansion
    ...
    set _EXITCODE=0
    &nbsp;
    for %%f in ("%~dp0") do set _ROOT_DIR=%%~sf
    &nbsp;
    call :props
    if not %_EXITCODE%==0 goto end
    &nbsp;
    call :args %*
    if not %_EXITCODE%==0 goto end
    rem ## Main
    if %_CLEAN%==1 (
        call :clean
        if not !_EXITCODE!==0 goto end
    )
    if %_COMPILE%==1 (
        call :compile
        if not !_EXITCODE!==0 goto end
    )
    if %_RUN%==1 (
        call :run
        if not !_EXITCODE!==0 goto end
    )
    goto end
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
    :run
    ...
    goto :eof
    :end
    ...
    exit /b %_EXITCODE%
    </pre>

2. [**`build.gradle`**](dotty-example-project/build.gradle) - [Gradle](http://www.gradle.org/) is a build tool which replaces XML based build scripts with an internal DSL which is based on [Groovy](http://www.groovy-lang.org/) programming language.The configuration file [**`build.gradle`**](dotty-example-project/build.gradle) for [**`examples\dotty-example-project`**](dotty-example-project/) looks as follows:
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

    In particular we note that [**`build.gradle`**](dotty-example-project/build.gradle)<ul><li>imports the two plugins: [**`java`**](https://docs.gradle.org/current/userguide/java_plugin.html) and [**`application`**](https://docs.gradle.org/current/userguide/application_plugin.html#header)</li><li>imports code (eg. task **`compileDotty`**) from the parent file [**`common.gradle`**](common.gradle)</li><li>assigns property **`mainClassName`** to **`main`** and value **`''`** to **`args`** (no argument in this case) in **`run.doFirst`**</li></ul>

3. [**`build.sbt`**](dotty-example-project/build.sbt) - This Sbt configuration file is a standalone file written in Scala.
    <pre style="font-size:80%;">
    val dottyVersion = "0.11.0-RC1"
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

4. [**`build.sc`**](dotty-example-project/build.sc) - This Mill configuration file is a standalone file written in Scala (with direct access to [OS-Lib](https://github.com/lihaoyi/os-lib)).
    <pre style="font-size:80%;">
    import mill._, scalalib._
    &nbsp;
    object go extends ScalaModule {
      def scalaVersion = "0.11.0-RC1"  // "2.12.18"
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

5. [**`build.xml`**](dotty-example-project/build.xml) - [Apache Ant](https://ant.apache.org/) is a Java-based build tool using XML-based configuration files. The configuration file [**`build.xml`**](dotty-example-project/build.xml) is a standalone file consisting of four targets and one macro definition to execute **`dotc.bat`**.
    <pre style="font-size:80%;">
    &lt;?xml version="1.0" encoding="UTF-8"?>
    &lt;project name="dotty-example-project" default="compile" basedir=".">
        ...
        &lt;target name="init"> ... &lt;/target>
        &lt;macrodef name="dotc"> ... &lt;/macrodef>
        &lt;target name="compile" depends="init"> ... &lt;/target>
        &lt;target name="run" depends="compile"> ... &lt;/target>
        &lt;target name="clean"> ... &lt;/target>
    &lt;/project>
    </pre>
6. [**`pom.xml`**](dotty-example-project/pom.xml) - This Maven configuration file the  **`dotty-example-project`** example depends on the parent file [**`pom.xml`**](pom.xml) which defines common properties (eg. **`java.version`**, **`scala.version`**):
    <pre style="font-size:80%;">
    &lt;?xml version="1.0" encoding="UTF-8"?>
    &lt;project xmlns="http://maven.apache.org/POM/4.0.0" ...>
        ...
        &lt;artifactId>dotty-example-projectlloWorld&lt;/artifactId>
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

## Session examples

### `dotty-example-project`

*(see [dotty-example-project](https://github.com/lampepfl/dotty-example-project) on Dotty Github)*

This project covers [Dotty](http://dotty.epfl.ch/) features such as trait parameters, enum types, implicit functions, implicit parameters, implicit conversions, union types, and so on.

### `enum-Color`

*(see example in [Dotty Documentation](http://dotty.epfl.ch/docs/reference/enums/enums.html))*

Executing the [**`build`**](enum-Color/build.bat) command in directory [**`examples\enum-Color\`**](enum-Color/) prints the following output:
<pre style="font-size:80%;">
> build clean compile run
Green
3
5
Green
3
</pre>

### `enum-HList`

Executing the [**`build`**](enum-HList/build.bat) command in directory [**`examples\enum-HList\`**](enum-HList/) prints no output since all assertions succeed:

<pre style="font-size:80%;">
> build clean compile run
</pre>

### `enum-Java`

Executing the [**`build`**](enum-Java/build.bat) command in directory [**`examples\enum-Java\`**](enum-Java/) prints the following output:
<pre style="font-size:80%;">
> build clean compile run
SUNDAY
A
SUNDAY
</pre>

### `enum-Planet`

*(see example in [Dotty Documentation](http://dotty.epfl.ch/docs/reference/enums/enums.html))*

Executing the [**`build`**](enum-Planet/build.bat) command in directory [**`examples\enum-Planet\`**](enum-Planet/) prints the following output:

<pre style="font-size:80%;">
> build -timer clean compile run
Compile time: 00:00:05
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
W:\dotty\examples\enum-Planet>
</pre>

**NB.** The `build` command takes the main class name and its arguments from the [**`project\build.properties`**](enum-Planet/project/build.properties) configuration file.

<pre style="font-size:80%;">
sbt.version=1.2.1

main.class=Planet
main.args=1
</pre>

Executing the `sbt` command in directory [**`examples\enum-Planet\`**](enum-Planet/) prints the following output:

<pre style="font-size:80%;">
> sbt clean compile "run 1"
[warn] Executing in batch mode.
...
[info] Done updating.
[info] Compiling 1 Scala source to W:\dotty\examples\enum-Planet\target\scala-0.9\classes...
[success] Total time: 4 s, completed 14 avr. 2018 21:36:42
[info] Running Planet 1
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
[success] Total time: 0 s, completed 14 avr. 2018 21:36:42
</pre>

### `enum-Tree`

Executing the [**`build`**](enum-Tree/build.bat) command in directory [**`examples\enum-Tree\`**](enum-Tree) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
If(IsZero(Pred(Succ(Zero))),Succ(Succ(Zero)),Pred(Pred(Zero))) --> 2
</pre>

### `hello-scala`

Executing the [**`build`**](hello-scala/build.bat) command in directory [**`examples\hello-scala\`**](hello-scala/) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
Hello!
Java Hello!
</pre>

### `ImplicitFunctionTypes`

Executing the [**`build`**](ImplicitFunctionTypes/build.bat) command in directory [**`examples\ImplicitFunctionTypes\`**](ImplicitFunctionTypes/) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
Table(Row(Cell(top left), Cell(top right)), Row(Cell(bottom left), Cell(bottom right)))
</pre>

### `IntersectionTypes`

Executing the [**`build`**](IntersectionTypes/build.bat) command in directory [**`examples\IntersectionTypes\`**](IntersectionTypes/) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
Buffer(first)
</pre>

### `PatternMatching`

Executing the [**`build`**](PatternMatching/build.bat) command in directory [**`examples\PatternMatching\`**](PatternMatching/) prints the following output:
<pre style="font-size:80%;">
> build clean compile run
even has an even number of characters
First: H; Second: i
e,x,a,m
5 is a natural number
List(3, 4)
</pre>

### `TypeLambdas-Underscore`

Executing the [**`build`**](TypeLambdas-Underscore/build.bat) command in directory [**`examples\TypeLambdas-Underscore\`**](TypeLambdas-Underscore/) prints the following output:
<pre style="font-size:80%;">
> build clean compile run
Type Aliases example:
11
11
11

Functors example:
functorForOption: Some(1)
Some(-1)
functorForList: List(Some(1), None, Some(2))
functorForList: List(None, Some(2))
functorForList: List(Some(2))
functorForList: List()
List(1, 0, 2)
</pre>

### `UnionTypes`

Executing the [**`build`**](UnionTypes/build.bat) command in directory [**`examples\UnionTypes\`**](UnionTypes/) prints the following output:
<pre style="font-size:80%;">
> build clean compile run
either=UserName(Eve)
</pre>

*[mics](http://lampwww.epfl.ch/~michelou/)/April 2018*






