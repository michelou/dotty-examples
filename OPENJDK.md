# <span id="top">OpenJDK and Scala 3 on Windows</span> <span style="size:30%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:80px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:80px;" src="docs/dotty.png" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    <a href="https://openjdk.java.net/faq/" rel="external">OpenJDK</a> is an open-source project initiated by Oracle in 2010. Java 8 is the first LTS version of Java to be released <i>both</i> as a commercial product (<a href="https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html">Oracle Java SE 8 </a>) and as an open-source product (<a href="https://adoptopenjdk.net/?variant=openjdk8&jvmVariant=hotspot" rel="external">Oracle OpenJDK 8</a>).<br/>In the following we focus on <a href="https://jdk.java.net/11/" rel="external">OpenJDK 11</a>, the current LTS version of Java.
  </td>
  </tr>
</table>

This document is part of a series of topics related to [Scala 3][scala3_home] on Windows:

- [Running Scala 3 on Windows](README.md)
- [Building Scala 3 on Windows](BUILD.md)
- [Data Sharing and Scala 3 on Windows](CDS.md)
- OpenJDK and Scala 3 on Windows [**&#9660;**](#bottom)

[JMH][jmh_project], [Metaprogramming][scala3_metaprogramming], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples] and [TruffleSqueak][trufflesqueak_examples] are other trending topics we are currently monitoring.


## <span id="proj_deps">Project dependencies</span>

This project depends on several external software for the **Microsoft Windows** platform:

- [Corretto OpenJDK 11][corretto_downloads] from [Amazon][amazon_aws] ([*release notes*][corretto_relnotes]).
- [Dragonwell OpenJDK 11][dragonwell_downloads] from [Alibaba][alibaba] ([*release notes*][dragonwell_relnotes]).
- [GraalVM OpenJDK 11][graalvm_downloads] from [Oracle] ([*release notes*][graalvm_relnotes]).
- [Liberica OpenJDK 11][bellsoft_downloads] from [BellSoft][bellsoft_about] ([*release notes*][bellsoft_relnotes]).
- [Microsoft OpenJDK][microsoft_downloads] from [Microsoft][microsoft].
- [OpenJ9 OpenJDK 11][openj9_downloads] from [IBM Eclipse](https://www.ibm.com/developerworks/rational/library/nov05/cernosek/index.html) ([*release notes*][openj9_relnotes], [*what's new?*][openj9_news]).
- [Oracle OpenJDK 11][oracle_openjdk_downloads] from [Oracle] ([*release notes*][oracle_openjdk_relnotes]).
- [RedHat OpenJDK 11][redhat_downloads] from [RedHat].
- [SapMachine OpenJDK 11](https://sap.github.io/SapMachine/) from [SAP][sap_home].
- [Trava OpenJDK 11][trava_downloads] from [Travis](https://travis-ci.com/) ([*release notes*][trava_relnotes]).
- [Zulu OpenJDK 11][azul_downloads] from [Azul Systems][azul_systems] ([*release notes*][azul_relnotes]).

<!--
https://devblogs.microsoft.com/java/announcing-general-availability-of-microsoft-build-of-openjdk/
-->

The above implementations of OpenJDK[&trade;][openjdk_trademark] differ in several ways:

- they are tested and certified for [JCK][openjdk_jck] <sup id="anchor_01">[[1]](#footnote_01)</sup> compliance excepted for Trava OpenJDK.
- they include different [backports](https://builds.shipilev.net/backports-monitor/) of fixes from OpenJDK 12 or newer (eg. [Corretto][corretto_patches]).
- they include additional modules (eg. Device IO API on Linux ARMv7) or integrate special tools (eg. HotswapAgent in [Trava](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm)).
- they support different sets of platform architectures (eg. [SapMachine](https://sap.github.io/SapMachine/) x64 only, [BellSoft][bellsoft_relnotes] also Raspberry Pi 2 &amp; 3).


> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [**`/opt/`**][unix_opt] directory on Unix).

For instance our development environment looks as follows (*July 2021*) <sup id="anchor_02">[[2]](#footnote_02)</sup>:

<pre style="font-size:80%;">
C:\opt\jdk-bellsoft-11.0.12\      <i>(300 MB)</i>
C:\opt\jdk-corretto-11.0.12_7\    <i>(293 MB)</i>
C:\opt\jdk-dcevm-11.0.11_1\       <i>(313 MB)</i>
C:\opt\jdk-dragonwell-11.0.11_0\  <i>(280 MB)</i>
C:\opt\graalvm-ce-java11-21.2.0\  <i>(731 MB)</i>
C:\opt\jdk-microsoft-11.0.11_9\   <i>(291 MB)</i>
C:\opt\jdk-openj9-11.0.11_9\      <i>(295 MB)</i>
C:\opt\jdk-openjdk-11.0.11_9\     <i>(299 MB)</i>
C:\opt\jdk-redhat-11.0.12.7-1\    <i>(364 MB)</i>
C:\opt\jdk-sapmachine-11.0.12\    <i>(316 MB)</i>
C:\opt\jdk-zulu-11.0.12\          <i>(302 MB)</i>
</pre>
<!-- hotspot   : 11.0.8 = 297 MB, 11.0.9 = 299 MB, 11.0.10 = 300 MB -->
<!-- corretto  : 11.0.8 = 290 MB, 11.0.9 = 292 MB, 11.0.10 = 292 MB -->
<!-- dcevm     : 11.0.8 = 296 MB, 11.0.9 = 296 MB, 11.0.10 = 313 MB-->
<!-- dragonwell: 11.0.11 = 307 MB -->
<!-- microsoft : 11.0.11 = 291 MB -->
<!-- sap       : 11.0.8 = 288 MB, 11.0.9 = 315 MB, 11.0.10 = 316 MB -->
<!-- zulu      : 11.0.8 = 299 MB, 11.0.9 = 300 MB, 11.0.10 = 301 MB -->

## <span id="build_times">Scala 3 build times</span>

We perform a quick comparison of the execution times to build the Scala 3 software distribution available as the following two archive files :
<pre style="font-size:80%;">
dist\target\scala3-3.0.3-RC1-bin-SNAPSHOT.tar.gz
dist\target\scala3-3.0.3-RC1-bin-SNAPSHOT.zip
</pre>

> **:mag_right:** Scala nightly builds are published on Maven as individual Java archive files, e.g.
> - [`scala3-compiler`](https://mvnrepository.com/artifact/org.scala-lang/scala3-compiler) (Scala 3 compiler)
> - [`scala3-library`](https://mvnrepository.com/artifact/org.scala-lang/scala3-library) (Scala 3 library)
> - and so on.

We ideally would run the command [`build -timer -verbose archives`](./bin/dotty/build.bat) to generate the above files (presuming all tests were successful).

Unfortunately a few tests still fail on Windows, so need to proceed in two steps, running the command [`build -timer -verbose clean boot & build -timer -verbose arch-only`](./bin/dotty/build.bat), in order to achieve our goal. 

Let's compare the build times for Java 11 and Java 8 on a Win10 laptop with an i7-8550U (1.8 GHz) processor and 16 Go of memory <sup id="anchor_03">[[3]](#footnote_03)</sup> :

| 11.0.12  | **Build&nbsp;time** | 1.8.0_302 | **Build&nbsp;time** |
|----------|---------------------|-----------|---------------------|
| [Corretto][corretto_downloads]<br/>(Amazon) |   31:48<br/>32:05 | [Corretto][corretto_downloads]<br/>(Amazon) | 25:45</br>26:02 | 01:15</br>01:15 | 27:00</br>27:27 |
| [DCEVM][trava_downloads]<br/>(Trava) <sup><b>a)</b></sup> | 33:40<br/>34:56 | [DCEVM][trava_downloads]<br/>(Trava) | n.a.            | n.a.            | n.a.            |
| [Dragonwell][dragonwell_downloads]<br/>(Alibaba) | 32:39<br/>32:00 | [Dragonwell][dragonwell8_downloads]<br/>(Alibaba) | 31:35<br/>32:02 | 01:17<br/>01:17 | 32:52<br/>33:19 |
| [Liberica][bellsoft_downloads]<br/>(BellSoft) | 32:18<br/>34:58 | [Liberica][bellsoft_downloads]<br/>(BellSoft) | 25:06<br/>24:44 | 01:09<br/>01:16 | 25:15<br/>26:00 |
| [Microsoft][microsoft_downloads] | <i>tbd</i> | [Microsoft][microsoft_downloads] | n.a.            | n.a.            | n.a.            |
| [OpenJ9][openj9_downloads]<br/>(Eclipse) | 37:41<br/>38:00 | [OpenJ9][openj9_downloads]<br/>(Eclipse) | 34:02<br/>33:16 |
| [OpenJDK][oracle_openjdk_downloads]<br/>(Oracle)  | 33:49<br/>33:45 | [OpenJDK][oracle_openjdk_downloads]<br/>(Oracle) | 26:24<br/>25:40 |
| [RedHat][redhat_downloads] | 31:46<br/>33:17 | [RedHat][redhat_downloads]    | 27:08<br/>26.32 |
| [Zulu][azul_downloads]<br/>(Azul)     | 32:31<br/>33:01 | [Zulu][azul_downloads]<br/>(Azul) | 26:17<br/>26:10 |
<div style="font-size:80%;">
<sup><b>a)</b></sup> DCEM Version 10.0.10.<br/>&nbsp;</div>

Here are some observations about the above results :
- The build process fails with [Corretto JDK][corretto_downloads] (ongoing investigation).
- Build times are ~10% longer with [OpenJ9 JDK][openj9_downloads] (for Java 11 and Java 8).
- Build times are significantly slower for Java 11 than for Java 8.

<!--
And we get the following build times for Java 11 and Java 8 look on a *slower* Win 10 laptop with an i7-47000MQ (2.4Ghz) processor and 12 Go of memory :

| 11.0.10  | `bootstrap`     | `arch-only`     | **Total**       | 1.8.0_282 | `bootstrap`     | `arch-only`     | **Total**       |
|----------|-----------------|-----------------|-----------------|-----------|-----------------|-----------------|-----------------|
| BellSoft | 42:19<br/>40:17 | 07:25<br/>07:37 | 49:44<br/>47:54 | BellSoft  | 32:69<br/>35:54 | 18:16<br/>04:37 | 51:15<br/>40:31 |
| Corretto | *Failure*       |                 |                 | Corretto  | *Failure*       |                 |                 |
| RedHat   | 46:44<br/>      | 07:24<br/>      | 54:08<br/>      | RedHat    | 32:33<br/>30:38 | 08:04<br/>08:56 | 40:37<br/>39:34 |
| OpenJ9   | 42:04<br/>50:47 | 16:40<br/>07:48 | 58:44<br/>58:35 | OpenJ9    | 38:45<br/>38:45 | 07:03<br/>05.19 | 57:08<br/>44:04 |
| OpenJDK  | 39:54<br/>44:34 | 07:42<br/>03:36 | 47:36<br/>48:10 | OpenJDK   | 32:07<br/>40:09 | 04:01<br/>05:17 | 36:08<br/>45:26 |
| Zulu     | 41:22<br/>      | 07:56<br/>      | 49:18<br/>      | Zulu      | 32:30<br/>32:40 | 06:50<br/>06:55 | 39:20<br/>39:35 |
<div style="font-size:80%;"><sup>(1)</sup>Build failure with "<code>Out of memory</code>" error.<br/>&nbsp;</div>
-->

## <span id="build_errors">Scala 3 build errors</span>

Build errors encountered on MS Windows on July 13, 2021, are :

| JVM 8 - Failing tests  | <a href="https://bell-sw.com/pages/downloads/#/java-8-lts">bellsoft-08</a> | <a href="https://github.com/corretto/corretto-8/releases">corretto-08</a> | <a href="https://github.com/alibaba/dragonwell8/releases">dragonwell-08</a> | <a href="https://adoptopenjdk.net/releases.html?variant=openjdk8&jvmVariant=openj9">openj9-08</a> | <a href="https://adoptopenjdk.net/releases.html?variant=openjdk8&jvmVariant=hotspot">openjdk-08</a> | <a href="https://developers.redhat.com/products/openjdk/download">redhat-08</a> | <a href="https://www.azul.com/downloads/?version=java-8-lts&package=jdk">zulu-08</a> |
|:-----------------------|:-----------:|:-----------:|:-------------:|:---------:|:----------:|:---------:|:-------:|
| `FromTastyTests`       | Failed      | Failed      | Failed        | Failed    | Failed     | Failed    | Failed  |
| `CompilationTest`      | OK          | OK          | OK            | Failed    | OK         | OK        | OK      |
| `ClasspathTests`       | Failed      | Failed      | Failed        | Failed    | Failed     | Failed    | Failed  |
| `ZipArchiveTest`       | OK          | OK          | OK            | Failed    | OK         | OK        | OK      |

| JVM 11 - Failing tests | <a href="https://bell-sw.com/pages/downloads/#/java-11-lts">bellsoft-11</a> | <a href="https://github.com/corretto/corretto-11/releases">corretto-11</a> | <a href="https://github.com/alibaba/dragonwell11/releases">dragonwell-11</a> | <a href="https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=openj9">openj9-11</a> | <a rhef="https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=hotspot">openjdk-11</a> | <a href="https://developers.redhat.com/products/openjdk/download">redhat-11</a> | <a href="https://github.com/SAP/SapMachine/releases">sapmachine-11</a> | <a href="https://www.azul.com/downloads/?version=java-11-lts&package=jdk">zulu-11</a> |
|:-----------------------|:-----------:|:-----------:|:-------------:|:---------:|:---------:|:---------:|:---------:|:-------:|
| `ClasspathTests  `     | Failed      | Failed      | Failed        | Failed    | Failed    | Failed    | Failed    | Failed  |
| `FromTastyTests`       | Failed      | Failed      | Failed        | Failed    | Failed    | Failed    | Failed    | Failed  |
| `MultiReleaseJarTest`  | Failed      | Failed      | Failed        | Failed    | Failed    | Failed    | Failed    | Failed  |

| JVM 17 - Failing tests | <a href="https://jdk.java.net/17/">openjdk-17</a> | <a href="https://github.com/SAP/SapMachine/releases">sapmachine-17</a> | <a href="https://www.azul.com/downloads/?version=java-17-ea&package=jdk">zulu-17</a> |
|:-----------------------|:----------:|:-------------:|:-------:|
| `FromTastyTests`       | &nbsp;     | Failed        | Failed  |
| `IdempotencyTests`     | &nbsp;     | Failed        | Failed  |
| `MultiReleaseJarTest`  | &nbsp;     | Failed        | Failed  |


## <span id="data_sharing">Data sharing</span>

This section supplements my writing from page [Data Sharing and Dotty on Windows](CDS.md).

An OpenJDK installation contains the file **`<install_dir>\lib\classlist`**. For instance we proceed as follows to check if data sharing is enabled in [Oracle OpenJDK 11][oracle_openjdk_downloads] :

1. Command **`java.exe -version`** displays the OpenJDK version amongst other information; in particular, the last output line ends with
   - **`(build 11.0.11+9, mixed mode, sharing)`** if data sharing is enabled
   - **`(build 11.0.11+9, mixed mode)`** otherwise.
2. Command **`java.exe -Xshare:dump`** generates the 17.3 Mb Java shared archive **`<install_dir>\bin\server\classes.jsa`** from file **`<install_dir>\lib\classlist`**.
3. We go back to step 1 to verify that flag  **`sharing`** is present.


### <span id="corretto">Corretto OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-corretto-11.0.12_7\bin\java -version</b>
openjdk version "11.0.12" 2021-07-20 LTS
OpenJDK Runtime Environment Corretto-11.0.12.7.1 (build 11.0.12+7-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.12.7.1 (build 11.0.12+7-LTS, mixed mode)

<b>&gt; c:\opt\jdk-corretto-11.0.12_7\bin\java -Xshare:dump</b>
[...]
Number of classes 1214
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-corretto-11.0.11_9\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
29.07.2021  11:51        17 694 720 classes.jsa

<b>&gt; c:\opt\jdk-corretto-11.0.12_7\bin\java -version</b>
openjdk version "11.0.12" 2021-07-20 LTS
OpenJDK Runtime Environment Corretto-11.0.12.7.1 (build 11.0.12+7-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.12.7.1 (build 11.0.12+7-LTS, mixed mode, sharing)
</pre>

> **:mag_right:** Amazon provides online documentation specific to Corretto 11 (eg. [change Log][corretto_changes], [patches][corretto_patches] as well as Youtube videos (eg. Devoxx keynotes by [Arun Gupta][corretto_gupta] and [James Gosling][corretto_gosling]).

### <span id="dragonwell">Dragonwell OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-dragonwell-11.0.11_0\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20
OpenJDK Runtime Environment (Alibaba Dragonwell) (build 11.0.11+0)
OpenJDK 64-Bit Server VM (Alibaba Dragonwell) (build 11.0.11+0, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-dragonwell-11.0.11_0\bin\java -Xshare:dump</b>
[...]
Number of classes 1258
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-dragonwell-11.0.11_0\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
29.07.2021  11:52        17 956 864 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-dragonwell-11.0.11_0\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20
OpenJDK Runtime Environment (Alibaba Dragonwell) (build 11.0.11+0)
OpenJDK 64-Bit Server VM (Alibaba Dragonwell) (build 11.0.11+0, mixed mode, sharing)
</pre>


### <span id="graalvm">GraalVM OpenJDK 11</span> [**&#9650;**](#top)

[GraalVM][graalvm_org] is a universal virtual machine supporting the *interaction* between JVM-based languages like Java, Scala, Groovy, Kotlin, Clojure and native languages like C, C++, JavaScript, Python, R, Ruby.

<pre style="font-size:80%;">
<b>&gt; c:\opt\graalvm-ce-java11-21.1.0\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20
OpenJDK Runtime Environment GraalVM CE 21.1.0 (build 11.0.11+8-jvmci-21.1-b05)
OpenJDK 64-Bit Server VM GraalVM CE 21.1.0 (build 11.0.11+8-jvmci-21.1-b05, mixed mode, sharing)
&nbsp;
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\graalvm-ce-java11-21.1.0\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
16.08.2020  08:41        17 563 648 classes.jsa
</pre>

We observe that [GraalVM][graalvm_org] is the only OpenJDK implementation to come with class sharing *enabled by default*.


### <span id="liberica">Liberica OpenJDK 11</span> [**&#9650;**](#top)

[Liberica OpenJDK 11][bellsoft_downloads] is available both as a *"regular"* and as a *"lite"* version (no JavaFX modules, compressed modules). BellSoft currently provides binaries suitable for different hardware and OS combinations, eg. Windows x86_64 and Windows x86.

In the following we work with the *"regular"* version of Liberica OpenJDK 11.

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-bellsoft-11.0.11\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20 LTS
OpenJDK Runtime Environment (build 11.0.11+9-LTS)
OpenJDK 64-Bit Server VM (build 11.0.11+9-LTS, mixed mode)

<b>&gt; c:\opt\jdk-bellsoft-11.0.11\bin\java -Xshare:dump</b>
[...]
Number of classes 1224
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-bellsoft-11.0.11\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
01.05.2021  16:38        17 760 256 classes.jsa

<b>&gt; c:\opt\jdk-bellsoft-11.0.11\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20 LTS
OpenJDK Runtime Environment (build 11.0.11+9-LTS)
OpenJDK 64-Bit Server VM (build 11.0.11+9-LTS, mixed mode, sharing)
</pre>

### <span id="microsoft">Microsoft OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-microsoft-11.0.11_9\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20
OpenJDK Runtime Environment Microsoft-22268 (build 11.0.11+9)
OpenJDK 64-Bit Server VM Microsoft-22268 (build 11.0.11+9, mixed mode)

<b>&gt; c:\opt\jdk-microsoft-11.0.11_9\bin\java -Xshare:dump</b>
[...]
Number of classes 1217
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-microsoft-11.0.11_9\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
30.07.2021  23:47        17 694 720 classes.jsa

<b>&gt; c:\opt\jdk-microsoft-11.0.11_9\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20
OpenJDK Runtime Environment Microsoft-22268 (build 11.0.11+9)
OpenJDK 64-Bit Server VM Microsoft-22268 (build 11.0.11+9, mixed mode, sharing)
</pre>


### <span id="openj9">OpenJ9 OpenJDK 11</span> [**&#9650;**](#top)

Compared to the other OpenJDK distributions OpenJ9 JDK 11 provides advanced settings to manage shared data; it uses option [**`-Xshareclasses:<params>`**](https://www.eclipse.org/openj9/docs/xshareclasses/) instead of **`-Xshare:<param>`**.
> **:mag_right:** Execute **`java -Xshareclasses:help`** to list the settings.

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-openj9-11.0.11_9\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20
OpenJDK Runtime Environment AdoptOpenJDK-11.0.11+9 (build 11.0.11+9)
Eclipse OpenJ9 VM AdoptOpenJDK-11.0.11+9 (build openj9-0.26.0, JRE 11 Windows 10 amd64-64-Bit Compressed References 20210421_976 (JIT enabled, AOT enabled)
OpenJ9   - b4cc246d9
OMR      - 162e6f729
JCL      - 7796c80419 based on jdk-11.0.11+9)

[XXXXXXXXXX -Xshareclasses:name=<name> ##########]
</pre>


### <span id="oracle">Oracle OpenJDK 11</span> [**&#9650;**](#top)

Oracle OpenJDK is the [reference implementation][oracle_openjdk_project]; the other OpenJDK distributions are derived from it.
<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-openjdk-11.0.11_9\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20
OpenJDK Runtime Environment AdoptOpenJDK-11.0.11+9 (build 11.0.11+9)
OpenJDK 64-Bit Server VM AdoptOpenJDK-11.0.11+9 (build 11.0.11+9, mixed mode)

<b>&gt; c:\opt\jdk-openjdk-11.0.11_9\bin\java -Xshare:dump</b>
[...]
Number of classes 1214
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-openjdk-11.0.11_9\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
01.05.2021  16:41        17 694 720 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-openjdk-11.0.11_9\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20
OpenJDK Runtime Environment AdoptOpenJDK-11.0.11+9 (build 11.0.11+9)
OpenJDK 64-Bit Server VM AdoptOpenJDK-11.0.11+9 (build 11.0.11+9, mixed mode, sharing)
</pre>


### <span id="redhat">RedHat OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-redhat-11.0.10_9-1\bin\java -version</b>
openjdk version "11.0.10" 2021-09-19 LTS
OpenJDK Runtime Environment 18.9 (build 11.0.10+9-LTS)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.10+9-LTS, mixed mode)

<b>&gt; c:\opt\jdk-redhat-11.0.10_9-1\bin\java -Xshare:dump</b>
[...]
Number of classes 1229
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-redhat-11.0.10_9-1\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
30.10.2020  10:09        17 760 256 classes.jsa

<b>&gt; c:\opt\jdk-redhat-11.0.10_9-1\bin\java -version</b>
openjdk version "11.0.10" 2021-01-19 LTS
OpenJDK Runtime Environment 18.9 (build 11.0.10+9-LTS)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.10+9-LTS, mixed mode, sharing)
</pre>


### <span id="sap">SapMachine OpenJDK 11</span> [**&#9650;**](#top)

GitHub project repository is [`SAP/SapMachine`](https://github.com/SAP/SapMachine).

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-sapmachine-11.0.12\bin\java -version</b>
openjdk version "11.0.12" 2021-07-20 LTS
OpenJDK Runtime Environment SapMachine (build 11.0.12+7-LTS-sapmachine)
OpenJDK 64-Bit Server VM SapMachine (build 11.0.12+7-LTS-sapmachine, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-sapmachine-11.0.12\bin\java -Xshare:dump</b>
[...]
Number of classes 1214
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-sapmachine-11.0.12\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
29.07.2021  11:54        17 694 720 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-sapmachine-11.0.12\bin\java -version</b>
openjdk version "11.0.12" 2021-07-20 LTS
OpenJDK Runtime Environment SapMachine (build 11.0.12+7-LTS-sapmachine)
OpenJDK 64-Bit Server VM SapMachine (build 11.0.12+7-LTS-sapmachine, mixed mode, sharing)
</pre>

> **:mag_right:** SAP provides [online documentation](https://github.com/SAP/SapMachine/wiki) specific to SapMachine 11, e.g. [Differences between SapMachine and OpenJDK](https://github.com/SAP/SapMachine/wiki/Differences-between-SapMachine-and-OpenJDK).

> **:mag_right:** SAP blog announcements:
> - [Re-Spin of OpenJDK/SapMachine 11.0.9 release](https://blogs.sap.com/2020/11/13/re-spin-of-openjdk-sapmachine-11.0.9-release/).


### <span id="trava">Trava OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-dcevm-11.0.11_1\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20
OpenJDK Runtime Environment AdoptOpenJDK-dcevm-11.0.11+1-202105021746 (build 11.0.11+1-202105021746)
Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK-dcevm-11.0.11+1-202105021746 (build 11.0.11+1-202105021746, mixed mode)

<b>&gt; c:\opt\jdk-dcevm-11.0.11_1\bin\java -Xshare:dump</b>
[...]
Number of classes 12629
[...]
total    :  18048312 [100.0% of total] out of  18219008 bytes [ 99.1% used
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-dcevm-11.0.10+4\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
30.10.2020  09:26        17 956 864 classes.jsa

<b>&gt; c:\opt\jdk-dcevm-11.0.11_1\bin\java -version</b>
openjdk version "11.0.11" 2021-04-20
OpenJDK Runtime Environment AdoptOpenJDK-dcevm-11.0.11+1-202105021746 (build 11.0.11+1-202105021746)
Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK-dcevm-11.0.11+1-202105021746 (build 11.0.11+1-202105021746, mixed mode, sharing)
</pre>

> **:mag_right:** [Trava OpenJDK](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases) is *not intended* to be used as 'main' JDK, since the integrated HotswapAgent is enabled by default and it uses serial GC by default. The default behaviour can be changed as follows:
> <pre style="font-size:80%;">
> <b>&gt; c:\opt\jdk-dcevm-11.0.11_1\bin\java -XX:+DisableHotswapAgent -XX:+UseConcMarkSweepGC -version</b>
> Dynamic Code Evolution 64-Bit Server VM warning: Option UseConcMarkSweepGC was deprecated in version 9.0 and will likely be removed in a future release.
> openjdk version "11.0.9" 2020-10-20
> OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.10+4-202010241925)
> Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.10+4-202010241925, mixed mode, sharing)
> </pre>
> Trava OpenJDK only supports the [serial and CMS garbage collectors](http://karunsubramanian.com/websphere/how-to-choose-the-correct-garbage-collector-java-generational-heap-and-garbage-collection-explained/) (ie. options `-XX:+UseParallelGC` and `-XX:+UseG1GC` are not supported).
> 
> Starting with <i>version 11.0.9</i> of the Trava OpenJDK the compiler option <code>-XX:+DisableHotswapAgent</code> is replaced
> by option <code>-XX:HotswapAgent:&lt;disabled|fatjar|core|external&gt;</code>.


### <span id="zulu">Zulu OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-zulu-11.0.12\bin\java -version</b>
openjdk version "11.0.12" 2021-07-20 LTS
OpenJDK Runtime Environment Zulu11.50+19-CA (build 11.0.12+7-LTS)
OpenJDK 64-Bit Server VM Zulu11.50+19-CA (build 11.0.12+7-LTS, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-zulu-11.0.12\bin\java -Xshare:dump</b>
[...]
Number of classes 1213
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-zulu-11.0.12\bin\server | <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> jsa</b>
29.07.2021  11:55        17 825 792 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-zulu-11.0.12\bin\java -version</b>
openjdk version "11.0.12" 2021-07-20 LTS
OpenJDK Runtime Environment Zulu11.50+19-CA (build 11.0.12+7-LTS)
OpenJDK 64-Bit Server VM Zulu11.50+19-CA (build 11.0.12+7-LTS, mixed mode, sharing)
</pre>

## <span id="related">Related reading</span> [**&#9650;**](#top)

### 2018

<dl>
  <dt><a href="https://developer.ibm.com/tutorials/j-class-sharing-openj9/">IBM Developer</a>:<a name="ref_03">&nbsp;</a>Class sharing in Eclipse OpenJ9</dt>
  <dd><i>by Ben Corrie, Hang Shao (2018-06-06)</i><br/>Reduce your memory footprint and improve startup performance with the shared class feature.</dd>
</dl>

### 2017

<dl>
  <dt><a href="https://www.slideshare.net/DanHeidinga/javaone-2017-eclipse-openj9-under-the-hood-of-the-jvm">JavaOne 2017</a>:<a name="ref_02">&nbsp;</a>Eclipse OpenJ9: Under the hood of the JVM</dt>
  <dd><i>by Dan Heidinga (2017-10-10)</i><br/>Dan Heiding presents an updated version of my "OpenJ9: Under the hood of the next open source JVM" that covers where it was open sourced (github.com/eclipse/openj9), how to build it, and then deep dives into the ROM/RAM divide before touching on interpreter, JIT and AOT.</dd>
</dl>

### 2016
<dl>
  <dt><a href="https://www.slideshare.net/DanHeidinga/j9-under-the-hood-of-the-next-open-source-jvm" rel="external">IBM</a>:<a name="ref_01">&nbsp;</a>OpenJ9: Under the hood of the next open source JVM</dt>
  <dd><i>by Dan Heidinga (2016-09-21)</i><br/>Dan Heidinga gives a description of how bytecodes are loaded into the J9VM and how bytecode execution occurs, plus IBM's plans to open source J9.</dd>
</dl>


## <span id="footnotes">Footnotes</span> [**&#9650;**](#top)

<span name="footnote_01" tooltip="[1]">[1]</span> ***JCK Compliance** (2018-04-06)* [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
The JCK is a proprietary test suite, <a href="https://openjdk.java.net/groups/conformance/JckAccess/index.html" rel="external">accessible under license from Oracle</a>.<br/>
The role of the JCK is not to determine <i>quality</i>, but rather to provide a binary indication of compatibility with the Java SE specification. As such, the JCK only tests functional behaviour, and only such functional behaviour that is given in the Java specification.<br/><i>(see <a href="https://github.com/AdoptOpenJDK/TSC/issues/19">issue 19</a> from <a href="https://github.com/AdoptOpenJDK/TSC">OpenJDK TSC</a>)</i>
</p>

<span name="footnote_02">[2]</span> ***Downloads*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
In our case we downloaded the following installation files (<a href="#proj_deps">see section 1</a>):
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<a href="https://github.com/alibaba/dragonwell11/releases">Alibaba_Dragonwell_11.0.11.7_x64_windows.zip</a>                   <i>(181 MB)</i>
<a href="https://github.com/corretto/corretto-11/releases" rel="external">amazon-corretto-11.0.12.7.1-windows-x64-jdk.zip</a>                <i>(178 MB)</i>
<a href="https://bell-sw.com/pages/downloads/#/java-11-lts">bellsoft-jdk11.0.12+7-windows-amd64.zip</a>                        <i>(187 MB)</i>
<a href="https://github.com/graalvm/graalvm-ce-builds/releases/tag/vm-21.2.0">graalvm-ce-java11-windows-amd64-21.2.0.zip</a>                     <i>(360 MB)</i>
<a href="https://developers.redhat.com/products/openjdk/download">java-11-openjdk-11.0.12.7-1.windows.redhat.x86_64.zip</a>          <i>(256 MB)</i>
<a href="https://docs.microsoft.com/en-us/java/openjdk/">microsoft-jdk-11.0.11.9.1-windows-x64.zip</a>                      <i>(177 MB)</i>
<a href="https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases/latest">Openjdk11u-dcevm-windows-x64.zip</a>                               <i>(187 MB)</i>
<a href="https://adoptopenjdk.net/?variant=openjdk11&jvmVariant=hotspot">OpenJDK11U-jdk_x64_windows_hotspot_11.0.10_1.zip</a>               <i>(190 MB)</i>
<a href="https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=openj9">OpenJDK11U-jdk_x64_windows_openj9_11.0.11+9_openj9-0.26.0.zip</a>  <i>(193 MB)</i>
<a href="https://github.com/SAP/SapMachine/releases/tag/sapmachine-11.0.11" rel="external">sapmachine-jdk-11.0.11_windows-x64_bin.zip</a>                     <i>(189 MB)</i>
<a href="https://www.azul.com/downloads/zulu-community/?version=java-11-lts" rel="external">zulu11.50.19-ca-jdk11.0.12-win_x64.zip</a>                         <i>(190 MB)</i>
</pre>

<span name="footnote_03">[3]</span> ***Snapshot builds*** [↩](#anchor_03)

<p style="margin:0 0 1em 20px;">
We run the batch file <a href="./bin/dotty/snapshot.bat"><code>snapshot.bat</code></a> (which calls <a href="./bin/dotty/build.bat"><code>build.bat</code></a>) to generate <b>19</b> Scala 3 distributions for <b>9</b> OpenJDK implementations (see snyk report "<a href="https://snyk.io/jvm-ecosystem-report-2021/">JVM Ecosystem report 2021"</a>).
</p>

<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> /b __SNAPSHOT_LOCAL</b>
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>bellsoft-08</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-bellsoft-08.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>bellsoft-11</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-bellsoft-11.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>corretto-11</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-corretto-11.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>dcevm-11</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-dcevm-11.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>dragonwell-08</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-dragonwell-08.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>dragonwell-11</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-dragonwell-11.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>microsoft-11</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-microsoft-11.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>openj9-08</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-openj9-08.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>openj9-11</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-openj9-11.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>openjdk-08</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-openjdk-08.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>openjdk-11</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-openjdk-11.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>openjdk-17</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-openjdk-17.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>redhat-08</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-redhat-08.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>redhat-11</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-redhat-11.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>sapmachine-11</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-sapmachine-11.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>sapmachine-17</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-sapmachine-17.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>zulu-08</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-zulu-08.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>zulu-11</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-zulu-11.zip
scala3-3.0.3-RC1-bin-SNAPSHOT-<b>zulu-17</b>.tar.gz
scala3-3.0.3-RC1-bin-SNAPSHOT-zulu-17.zip
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/July 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[alibaba]: https://www.alibabagroup.com/en/global/home
[amazon_aws]: https://aws.amazon.com/
[corretto_downloads]: https://github.com/corretto/corretto-11/releases
[corretto_relnotes]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/change-log.html
[azul_downloads]: https://www.azul.com/downloads/zulu/zulu-windows
[azul_relnotes]: https://docs.azul.com/zulu/zulurelnotes/index.htm#ZuluReleaseNotes/ReleaseDetails1129-834-726.htm
[azul_systems]: https://www.azul.com/
[bellsoft_about]: https://bell-sw.com/pages/about
[bellsoft_downloads]: https://bell-sw.com/pages/downloads/#/java-11-lts
[bellsoft_relnotes]: https://bell-sw.com/pages/liberica-release-notes-11.0.11/
[corretto_changes]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/change-log.html
[corretto_gosling]: https://www.youtube.com/watch?v=WuZk23O76Zk
[corretto_gupta]: https://www.youtube.com/watch?v=RLKC5nsiZXU
[corretto_patches]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/patches.html
[dragonwell_downloads]: https://github.com/alibaba/dragonwell11/releases/tag/dragonwell-11.0.11.7_jdk-11.0.11-ga
[dragonwell_relnotes]: https://github.com/alibaba/dragonwell11/wiki/Alibaba-Dragonwell-11-Release-Notes#110117
[dragonwell8_downloads]: https://github.com/alibaba/dragonwell8/releases
[graalvm_downloads]: https://github.com/graalvm/graalvm-ce-builds/releases
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[graalvm_org]: https://www.graalvm.org/
[graalvm_relnotes]: https://www.graalvm.org/release-notes/21_1/
[haskell_examples]: https://github.com/michelou/haskell-examples
[jmh_project]: https://openjdk.java.net/projects/code-tools/jmh/
[kotlin_examples]: https://github.com/michelou/kotlin-examples
[llvm_examples]: https://github.com/michelou/llvm-examples
[microsoft]: https://docs.microsoft.com/en-us/java/
[microsoft_downloads]: https://docs.microsoft.com/en-us/java/openjdk/download#generally-available-ga-builds
[nodejs_examples]: https://github.com/michelou/nodejs-examples
[openj9_downloads]: https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=openj9
[openj9_news]: https://www.eclipse.org/openj9/oj9_whatsnew.html
[openj9_relnotes]: https://github.com/eclipse/openj9/releases/
[openjdk_jck]: https://openjdk.java.net/groups/conformance/JckAccess/
[openjdk_trademark]: https://openjdk.java.net/legal/openjdk-trademark-notice.html
[oracle]: https://www.oracle.com/
[oracle_openjdk_project]: https://openjdk.java.net/projects/jdk/11/
[oracle_openjdk_downloads]: https://adoptopenjdk.net/?variant=openjdk11&jvmVariant=hotspot
[oracle_openjdk_relnotes]: https://adoptopenjdk.net/release_notes.html?variant=openjdk11&jvmVariant=hotspot#jdk11_0_10
[redhat]: https://www.redhat.com/
[redhat_downloads]: https://developers.redhat.com/products/openjdk/download/
[sap_home]: https://www.sap.com/
[scala3_home]: https://dotty.epfl.ch/
[scala3_metaprogramming]: https://dotty.epfl.ch/docs/reference/metaprogramming/toc.html
[trava_downloads]: https://github.com/TravaOpenJDK/trava-jdk-11-dcevm
[trava_relnotes]: https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[unix_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
