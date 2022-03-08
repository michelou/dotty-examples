# <span id="top">Maven Plugins</span> <span style="size:30%;"><a href="../README.md">⬆</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:100px;" src="../docs/images/dotty.png" width="100" alt="Dotty project"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <strong><code>maven-plugins\</code></strong> contains <a href="https://maven.apache.org/plugins">Maven plugin</a> examples found on the Web or written by ourself.<br/>Our final objective to compile Scala source files from a POM file using the <a href="https://maven.apache.org/ref/current/maven-embedder/cli.html">Maven command line tool</a>.
  </td>
  </tr>
</table>

In the past years at least two [Maven plugins][apache_maven_plugins] for Scala have been developed, i.e. David's [`scala-maven-plugin`](https://davidb.github.io/scala-maven-plugin/) and the *outdated* plugin [`maven-scala-plugin`](https://mvnrepository.com/artifact/org.scala-tools/maven-scala-plugin) (February 2011).

We were no satisfied with the above plugins and decided in late 2018 to write our own [Maven plugin][apache_maven_plugins] for compiling <sup id="anchor_01"><a href="#footnote_01">1</a></sup> the Scala source files of our [Scala] projects (see for instance [`examples\README.md`](../examples/README.md)).

> **&#9755;** ***Plugin naming convention***<br/>
> The [*Maven Guide to Developing Java Plugins*](https://maven.apache.org/guides/plugin/guide-java-plugin-development.html) starts with an important notice that recommand us to name our plugin <code>&lt;yourplugin&gt;-maven-plugin</code>.

## <span id="first_plugin">`first-maven-plugin`</span>

This plugin project is adapted from the code example presented in section 11.4 &ndash; [Writing a Custom Plugin](https://books.sonatype.com/mvnref-book/reference/writing-plugins-sect-custom-plugin.html) &ndash; of the online book [*Maven: The Complete Reference*](https://books.sonatype.com/mvnref-book/reference/index.html).

The project is organized as follows:

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./first-maven-plugin/00download.txt">00download.txt</a>
|   <a href="./first-maven-plugin/build.bat">build.bat</a>
|   <a href="./first-maven-plugin/pom.xml">pom.xml</a>
|
+---src
    \---main
        \---java
            \---org
                \---sonatype
                    \---plugins
                             <a href="./first-maven-plugin/src/main/java/org/sonatype/plugins/EchoMojo.java">EchoMojo.java</a>
</pre>

*WIP* <sup id="anchor_02"><a href="#footnote_02">2</a></sup>

## <span id="hello_plugin">`hello-maven-plugin`</span>

The plugin project `hello-maven-plugin` is the code example presented in the online [*Maven Guide to Developing Java Plugins*](https://maven.apache.org/guides/plugin/guide-java-plugin-development.html).

The project is organized as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="">tree</a> /a /f . |<a href="">findstr</a> /v /b [A-Z]</b>
|   <a href="./hello-maven-plugin/00download.txt">00download.txt</a>
|   <a href="./hello-maven-plugin/install-local.bat">install-local.bat</a>
|   <a href="./hello-maven-plugin/pom.xml">pom.xml</a>
|
+---src
|   \---main
|       +---java
|           \---sample
|               \---plugin
|                       <a href="./hello-maven-plugin/src/main/java/sample/plugin/GreetingMojo.java">GreetingMojo.java</a>
\---test
    |   <a href="./hello-maven-plugin/test/pom.xml">test\pom.xml</a>
    \---src
        \---main
            +---java
                    <a href="./hello-maven-plugin/test/src/main/java/Dummy.java">Dummy.java</a>
</pre>

*WIP*

## <span id="scala_maven_plugin">`scala-maven-plugin`</span>

We started this project in late 2018; we use **`scala-maven-plugin`** in all Scala projects of our GitHub repository [`michelou/dotty-examples`](https://github.com/michelou/dotty-examples) (but not only).

**`scala-maven-plugin`** features two goals with parameters similar to the [**`maven-compiler-plugin`**](https://maven.apache.org/plugins/maven-compiler-plugin/plugin-info.html):

| Goal     | Parameters |
|:---------|:-----------|
| `compile`| `additionalClasspathElements`<br/>`addOutputToClasspath`<br/>`compilerArgs`<br/>`excludes`<br/>`includes` |
| `run`    | `jvmArgs`|

The project is organized as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f . |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./scala-maven-plugin/pom.xml">pom.xml</a>
|
+---src
    \---main
        \---java
            \---ch
                \---epfl
                    \---alumni
                            <a href="./scala-maven-plugin/src/main/java/ch/epfl/alumni/HelpMojo.java">HelpMojo.java</a>
                            <a href="./scala-maven-plugin/src/main/java/ch/epfl/alumni/ScalaAbstractMojo.java">ScalaAbstractMojo.java</a>
                            <a href="./scala-maven-plugin/src/main/java/ch/epfl/alumni/ScalaCompileMojo.java">ScalaCompileMojo.java</a>
                            <a href="./scala-maven-plugin/src/main/java/ch/epfl/alumni/ScalaRunMojo.java">ScalaRunMojo.java</a>
</pre>

Command [**`mvn`** `package`][apache_maven_cli] generates the JAR file `scala-maven-plugin-1.0.0.jar` to be deployed as Maven artifact :

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/ref/current/maven-embedder/cli.html">mvn</a> clean compile package</b>
[INFO] Scanning for projects...
[...]
[INFO] java-javadoc mojo extractor found 0 mojo descriptor.
[INFO] bsh mojo extractor found 0 mojo descriptor.
[INFO] ant mojo extractor found 0 mojo descriptor.
[INFO] java-annotations mojo extractor found 3 mojo descriptors.
[...]
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b target\*.jar</b>
scala-maven-plugin-1.0.0.jar
</pre>

Command [**`mvn`** `deploy:deploy-file`][apache_maven_cli] installs the Maven artifact for our plugin into our local Maven repository <code><a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\\.m2\repository\\</code> :

<pre style="font-size:80%;">
<b>&gt; <a href="https://maven.apache.org/ref/current/maven-embedder/cli.html">mvn</a> deploy:deploy-file -DgroupId=ch.epfl.alumni -DartifactId=scala-maven-plugin -Dversion=1.0.0 -Durl=file://%USERPROFILE%/.m2/repository -DupdateReleaseInfo=true -Dfile=.\target\scala-maven-plugin-1.0.0.jar -Dpackaging=jar -DpomFile=.\pom.xml -DgeneratePom=true -DcreateChecksum=true</b>
[INFO] Scanning for projects...
[...]
</pre>

> **&#9755;** **`scala-maven-plugin` *Installation***<br/>
> A user has currently two possibilities to install `scala-maven-plugin`:
> - Download our source project, generate and install the plugin as described above.
> - Download and extract the Zip file [`scala-maven-plugin-1.0.zip`](../bin/scala-maven-plugin-1.0.zip) into the local Maven repository.
>
> The plugin installation should look as follows :
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f <a href="https://en.wikipedia.org/wiki/Environment_variable#Default_values">%USERPROFILE%</a>\.m2\repository\ch\epfl\alumni |<a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
> \---scala-maven-plugin
>     |   maven-metadata-remote-repository.xml
>     |   maven-metadata-remote-repository.xml.sha1
>     |   maven-metadata.xml
>     |   maven-metadata.xml.md5
>     |   maven-metadata.xml.sha1
>     |   resolver-status.properties
>     |
>     \---1.0.0
>             scala-maven-plugin-1.0.0.jar
>             scala-maven-plugin-1.0.0.jar.md5
>             scala-maven-plugin-1.0.0.jar.sha1
>             scala-maven-plugin-1.0.0.pom
>             scala-maven-plugin-1.0.0.pom.md5
>             scala-maven-plugin-1.0.0.pom.sha1
> </pre>

<!--
- [POM Code Convention](https://maven.apache.org/developers/conventions/code.html#pom-code-convention)
-->

<!-- ##################################################################### -->

## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> ***pom.xml*** [↩](#anchor_01)

<dl><dd>
We give here the <code>&lt;plugin></code> section of a POM file.
</dd>
<dd>
<pre style="font-size:80%;">
<b>&lt;plugin></b>
    <b>&lt;groupId></b>ch.epfl.alumni<b>&lt;/groupId></b>
    <b>&lt;artifactId></b>scala-maven-plugin<b>&lt;/artifactId></b>
    <b>&lt;version></b>${scala.maven.version}<b>&lt;/version></b>
    <b>&lt;executions></b>
        <b>&lt;execution></b>
            <b>&lt;id></b>scala-compile<b>&lt;/id></b>
            <b>&lt;phase></b>compile<b>&lt;/phase></b>
            &lt;goals>
                <b>&lt;goal></b>compile<b>&lt;/goal></b>
            <b>&lt;/goals></b>
            <b>&lt;configuration></b>
                &lt;additionalClasspathElements>
                    &lt;additionalClasspathElement>${m2.hamcrest.jar}&lt;/additionalClasspathElement>
                    &lt;!-- ...more additions.. -->
                <b>&lt;/additionalClasspathElements></b>
                &lt;includes>
                    <b>&lt;include></b>scala/**/*.scala<b>&lt;/include></b>
                &lt;/includes>
                &lt;installDirectory>${env.SCALA3_HOME}</installDirectory>
            <b>&lt;/configuration></b>
        <b>&lt;/execution></b>
        &lt;!-- ...execution of "run" goal... -->
    <b>&lt;/executions></b>
    <b>&lt;configuration></b>
        <b>&lt;scalaVersion></b>${scala.version}<b>&lt;/scalaVersion></b>
        <b>&lt;localInstall></b>${scala.local.install}<b>&lt;/localInstall></b>
        &lt;!-- &lt;debug>true&lt;/debug> -->
        <b>&lt;jvmArgs></b>
            <b>&lt;jvmArg></b>-Xms64m<b>&lt;/jvmArg></b>
            <b>&lt;jvmArg></b>-Xmx1024m<b>&lt;/jvmArg></b>
        <b>&lt;/jvmArgs></b>
    <b>&lt;/configuration></b>
<b>&lt;/plugin></b>
</pre>
</dd></dl>

<span id="footnote_02">[2]</span> ***META-INF/maven/plugin.xml*** [↩](#anchor_02)

<dl><dd>
<pre style="font-size:80%;">
<b>&lt;plugin></b>
  <b>&lt;name></b>Sample Parameter-less Maven Plugin<b>&lt;/name></b>
  <b>&lt;description></b><b>&lt;/description></b>
  <b>&lt;groupId></b>sample.plugin<b>&lt;/groupId></b>
  <b>&lt;artifactId></b>hello-maven-plugin<b>&lt;/artifactId></b>
  <b>&lt;version></b>1.0-SNAPSHOT<b>&lt;/version></b>
  <b>&lt;goalPrefix></b>hello<b>&lt;/goalPrefix></b>
  <b>&lt;isolatedRealm></b>false<b>&lt;/isolatedRealm></b>
  <b>&lt;inheritedByDefault></b>true<b>&lt;/inheritedByDefault></b>
  <b>&lt;mojos></b>
    <b>&lt;mojo></b>
      <b>&lt;goal></b>sayhi<b>&lt;/goal></b>
      &lt;description>Says &quot;Hi&quot; to the user.&lt;/description>
      &lt;requiresDirectInvocation>false&lt;/requiresDirectInvocation>
      &lt;requiresProject>true&lt;/requiresProject>
      &lt;requiresReports>false&lt;/requiresReports>
      &lt;aggregator>false&lt;/aggregator>
      &lt;requiresOnline>false&lt;/requiresOnline>
      &lt;inheritedByDefault>true&lt;/inheritedByDefault>
      &lt;implementation>sample.plugin.GreetingMojo&lt;/implementation>
      &lt;language>java&lt;/language>
      &lt;instantiationStrategy>per-lookup&lt;/instantiationStrategy>
      &lt;executionStrategy>once-per-session&lt;/executionStrategy>
      &lt;threadSafe>false&lt;/threadSafe>
      <b>&lt;parameters/></b>
    <b>&lt;/mojo></b>
  <b>&lt;/mojos></b>
  <b>&lt;dependencies/></b>
<b>&lt;/plugin></b>
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2022* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[apache_maven_cli]: https://maven.apache.org/ref/current/maven-embedder/cli.html
[apache_maven_plugins]: https://maven.apache.org/plugins
[scala]: https://www.scala-lang.org/
