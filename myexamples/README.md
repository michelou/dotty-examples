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

Each example in directory **`myexamples\`** can also be built using [**`sbt`**](https://www.scala-sbt.org/), [**`ant`**](https://ant.apache.org/manual/running.html), [**`gradle`**](https://docs.gradle.org/current/userguide/command_line_interface.html), [**`mill`**](http://www.lihaoyi.com/mill/#command-line-tools) or [**`mvn`**](http://maven.apache.org/ref/3.6.0/maven-embedder/cli.html) as an alternative to the **`build`** batch command.

## Build tools

In this section we explain in more detail the available build tools available in the [**`myexamples\HelloWorld`**](HelloWorld/) example (and also in other examples from directory **`myexamples\`**):

1. [**`build.bat`**](HelloWorld/build.bat) - This batch command is a basic build tool consisting of ~350 lines of batch/[Powershell ](https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-started-with-windows-powershell?view=powershell-6) code.
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

2. [**`build.gradle`**](HelloWorld/build.gradle) - [Gradle](http://www.gradle.org/) is a build tool which replaces XML based build scripts with an internal DSL which is based on [Groovy](http://www.groovy-lang.org/) programming language. The configuration file [**`build.gradle`**](HelloWorld/build.gradle) for [**`myexamples\HelloWorld`**](HelloWorld/) looks as follows:
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

    We note that [**`build.gradle`**](HelloWorld/build.gradle)<ul><li>imports the two plugins: [**`java`**](https://docs.gradle.org/current/userguide/java_plugin.html) and [**`application`**](https://docs.gradle.org/current/userguide/application_plugin.html#header)</li><li>imports code from the parent file [**`common.gradle`**](common.gradle)</li><li>assigns property **`mainClassName`** to **`main`** and value **`''`** to **`args`** (no argument in this case) in **`run.doFirst`**</li></ul>

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

3. [**`build.sbt`**](HelloWorld/build.sbt) - This Sbt configuration file is a standalone file written in [Scala](https://www.scala-lang.org/) and it obeys the [sbt build definitions](https://www.scala-sbt.org/1.0/docs/Basic-Def.html).
    <pre style="font-size:80%;">
    val dottyVersion = "0.11.0-RC1"
    &nbsp;
    lazy val root = project
      .in(file("."))
      .settings(
        name := "HelloWorld",
        description := "Example sbt project that compiles using Dotty",
        version := "0.1.0",
        &nbsp;
        scalaVersion := dottyVersion,
        scalacOptions ++= Seq(
          "-deprecation"
        )
      )
    </pre>

4. [**`build.sc`**](HelloWorld/build.sc) - This Mill configuration file is a standalone file written in Scala written in Scala (with direct access to [OS-Lib](https://github.com/lihaoyi/os-lib)).
    <pre style="font-size:80%;">
    import mill._, scalalib._
    &nbsp;
    object go extends ScalaModule {
      def scalaVersion = "0.11.0-RC1"  // "2.12.18"
      def scalacOptions = Seq("-deprecation", "-feature")
      def forkArgs = Seq("-Xmx1g")
      def mainClass = Some("HelloWorld")
      def sources = T.sources { os.pwd / 'src }
    }
    </pre>

5. [**`build.xml`**](HelloWorld/build.xml) - [Apache Ant](https://ant.apache.org/) is a Java-based build tool using XML-based configuration files. The configuration file [**`build.xml`**](HelloWorld/build.xml) is a standalone file consisting of four targets and one macro definition to execute the external batch command **`dotc.bat`** (**WIP** : [Ivy](http://ant.apache.org/ivy/) support).
    <pre style="font-size:80%;">
    &lt;?xml version="1.0" encoding="UTF-8"?>
    &lt;project name="HelloWorld" default="compile" basedir=".">
        ...
        &lt;target name="init"> ... &lt;/target>
        &lt;macrodef name="dotc"> ... &lt;/macrodef>
        &lt;target name="compile" depends="init"> ... &lt;/target>
        &lt;target name="run" depends="compile"> ... &lt;/target>
        &lt;target name="clean"> ... &lt;/target>
    &lt;/project>
    </pre>

6. [**`pom.xml`**](HelloWorld/pom.xml) - The Maven configuration file in the **`HelloWorld`** example depends on the parent file [**`..\pom.xml`**](../pom.xml) which defines common properties (eg. **`java.version`**, **`scala.version`**)
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

## Session examples

### `00_AutoParamTupling`

Executing the [**`build`**](00_AutoParamTupling/build.bat) command in directory [**`myexamples\00_AutoParamTupling\`**](00_AutoParamTupling/) 
prints the following output:

<pre style="font-size:80%;">
> build clean compile run
: d : o : t : t : y
0: d 1: o 2: t 3: t 4: y
0,-1: d 1,-2: o 2,-3: t 3,-4: t 4,-5: y
0,-1: d 1,-2: o 2,-3: t 3,-4: t 4,-5: y
0,-1: d 1,-2: o 2,-3: t 3,-4: t 4,-5: y
</pre>

### `01_Dependent_Types`

Executing the [**`build`**](01_Dependent_Types/build.bat) command in directory [**`myexamples\01_Dependent_Types\`**](01_Dependent_Types/) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
params=Map(grade -> C, sort -> time, width -> 120)
</pre>

### `02_Union_Types`

Executing the [**`build`**](02_Union_Types/build.bat) command in directory [**`myexamples\02_Union_Types\`**](02_Union_Types/) prints the following output:

<pre style="font-size:80%;">
> build -timer clean compile run
Compile time: 00:00:05
testIntFloat example:
Float 0.0
Int 4

testDivision example:
Success(0.5)
DivisionByZero
0.5
Division failed

testMessage example:
https://www.google.com
Dotty

testJSON example:
1
[1, "abc", true]
{a: 1, b: "blue", c: [1, "abc", true]}
</pre>

### `03_Intersection_Types`

Executing the [**`build`**](03_Intersection_Types/build.bat) command in directory [**`myexamples\03_Intersection_Types\`**](03_Intersection_Types/) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
Buffer(1,2,3,4)
</pre>

### `04_Multiversal_Equality`

Executing the [**`build`**](04_Multiversal_Equality/build.bat) command in directory [**`myexamples\04_Multiversal_Equality\`**](04_Multiversal_Equality/) prints the following output:

<pre>
> build clean compile run
test1 example:
false
false

test2 example:
false                             
false                             
                                  
testCharInt example:              
false
false
true                              
true                              
                                  
testBooleanChar example:          
true                              
false                             
</pre>

### [`bug4272`](https://github.com/lampepfl/dotty/issues/4272)

Executing the [**`build`**](bug4272/build.bat) command in directory [**`myexamples\bug4272\`**](bug4272/) produces a runtime exception with version 0.7 of the Dotty compiler (*was fixed in version 0.8*):

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

### [`bug4356`](https://github.com/lampepfl/dotty/issues/4356)

Executing the `build` command in directory **`myexamples\bug4356\`** produces a runtime exception with version 0.7 of the Dotty compiler:

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

### `HelloWorld`

Executing the [**`build`**](HelloWorld/build.bat) command in directory [**`myexamples\HelloWorld\`**](HelloWorld/) prints the following output:

<pre>
> build clean compile run
Hello world!
</pre>

*[mics](http://lampwww.epfl.ch/~michelou/)/December 2018* [**&#9650;**](#top)






