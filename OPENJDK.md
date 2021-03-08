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

This document is part of a series of topics related to [Dotty] on Windows:

- [Running Scala 3 on Windows](README.md)
- [Building Scala 3 on Windows](BUILD.md)
- [Data Sharing and Scala 3 on Windows](CDS.md)
- OpenJDK and Scala 3 on Windows [**&#9660;**](#bottom)

[JMH][jmh_project], [Metaprogramming][dotty_metaprogramming], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples] and [TruffleSqueak][trufflesqueak_examples] are other trending topics we are currently monitoring.


## <span id="proj_deps">Project dependencies</span>

This project depends on several external software for the **Microsoft Windows** platform:

- [Corretto OpenJDK 11][corretto_downloads] from [Amazon][amazon_aws] ([*release notes*][corretto_relnotes]).
- [GraalVM OpenJDK 11][graalvm_downloads] from [Oracle] ([*release notes*][graalvm_relnotes]).
- [Liberica OpenJDK 11][bellsoft_downloads] from [BellSoft][bellsoft_about] ([*release notes*][bellsoft_relnotes]).
- [OpenJ9 OpenJDK 11][openj9_downloads] from [IBM Eclipse](https://www.ibm.com/developerworks/rational/library/nov05/cernosek/index.html) ([*release notes*][openj9_relnotes], [*what's new?*][openj9_news]).
- [Oracle OpenJDK 11][oracle_openjdk_downloads] from [Oracle] ([*release notes*][oracle_openjdk_relnotes]).
- [RedHat OpenJDK 11][redhat_downloads] from [RedHat].
- [SapMachine OpenJDK 11](https://sap.github.io/SapMachine/) from [SAP][sap_home].
- [Trava OpenJDK 11][trava_downloads] from [Travis](https://travis-ci.com/) ([*release notes*][trava_relnotes]).
- [Zulu OpenJDK 11][azul_downloads] from [Azul Systems][azul_systems] ([*release notes*][azul_relnotes]).

The above implementations of OpenJDK[&trade;][openjdk_trademark] differ in several ways:

- they are tested and certified for [JCK][openjdk_jck] <sup id="anchor_01">[[1]](#footnote_01)</sup> compliance excepted for Trava OpenJDK.
- they include different [backports](https://builds.shipilev.net/backports-monitor/) of fixes from OpenJDK 12 or newer (eg. [Corretto][corretto_patches]).
- they include additional modules (eg. Device IO API on Linux ARMv7) or integrate special tools (eg. HotswapAgent in [Trava](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm)).
- they support different sets of platform architectures (eg. [SapMachine](https://sap.github.io/SapMachine/) x64 only, [BellSoft][bellsoft_relnotes] also Raspberry Pi 2 &amp; 3).


> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [**`/opt/`**][unix_opt] directory on Unix).

For instance our development environment looks as follows (*March 2021*) <sup id="anchor_02">[[2]](#footnote_02)</sup>:

<pre style="font-size:80%;">
C:\opt\jdk-11.0.10+9\             <i>(299 MB)</i>
C:\opt\jdk-bellsoft-11.0.10\      <i>(317 MB)</i>
C:\opt\jdk-corretto-11.0.10_9\    <i>(292 MB)</i>
C:\opt\jdk-dcevm-11.0.9+1\        <i>(295 MB)</i>
C:\opt\graalvm-ce-java11-21.0.0\  <i>(731 MB)</i>
C:\opt\jdk-openj9-11.0.10+9\      <i>(295 MB)</i>
C:\opt\jdk-redhat-11.0.10.9-1\    <i>(363 MB)</i>
C:\opt\jdk-sapmachine-11.0.10\    <i>(315 MB)</i>
C:\opt\jdk-zulu-11.0.10\          <i>(300 MB)</i>
</pre>
<!-- hotspot : 11.0.8 = 297 MB, 11.0.9 = 299 MB -->
<!-- corretto: 11.0.8 = 290 MB, 11.0.9 = 292 MB, 11.0.10 = 2892 MB -->
<!-- dcevm   : 11.0.8 = 296 MB, 11.0.9 = 296 MB -->
<!-- sap     : 11.0.8 = 288 MB, 11.0.9 = 315 MB -->
<!-- zulu    : 11.0.8 = 299 MB, 11.0.9 = 300 MB -->

## <span id="build_times">Scala 3 build times</span>

In this section we are interested in the execution time used to generate the following two archive files, i.e. an installation-ready Scala 3 distribution :
<pre style="font-size:80%;">
dist\target\scala3-3.0.0-RC2-bin-SNAPSHOT.tar.gz
dist\target\scala3-3.0.0-RC2-bin-SNAPSHOT.zip
</pre>

Ideally we would run the command `build -timer -verbose archives` to generate those two files. Unfortunately several tests do fail when run on Windows, so we have to fallback to the chained commands `build -timer -verbose clean boot & build -timer -verbose arch-only` to achieve that goal. 

Let's compare the elapsed build times with Java 11 and Java 8 on a machine with an i7-8550U (1.8 GHz) processor and 16 Go of memory :

| 11.0.10  | `bootstrap`     | `arch-only`     | **Total**       | 1.8.0_282 | `bootstrap`      | `arch-only`       | **Total**       |
|----------|-----------------|-----------------|-----------------|-----------|-----------------|-----------------|-----------------|
| BellSoft | 31:06<br/>33:42 | 01:10<br/>01:16 | 32:16<br/>34:58 | BellSoft  | 25:40<br/>24:44 | 01:16<br/>01:16 | 26:56<br/>26:00 |
| Corretto | *Failure*       |                 |                 | Corretto  | *Failure*       |                 |                 |
| RedHat   |                 |                 |                 | RedHat    | 24:37<br/>25:19 | 01:11<br/>01:13 | 25:48<br/>26.32 |
| OpenJ9   | 26:23<br/>36:42 | 01:18<br/>01:18 | 37:41<br/>38:00 | OpenJ9    | 31:40<br/>31:56 | 01:18<br/>01:20 | 32:58<br/>33:16 |
| OpenJDK  | 32:44<br/>32:38 | 01:05<br/>01:07 | 33:49<br/>33:45 | OpenJDK   | 24:25<br/>24:30 | 01:12<br/>01:10 | 25:37<br/>25:40 |
| Zulu     | 31:01<br/>31:54 | 01:07<br/>01:07 | 32:08<br/>33:01 | Zulu      | 24:21<br/>24:57 | 01:12<br/>01:13 | 25:33<br/>26:10 |

We compare the elapsed build times with Java 11 and Java 8 on a machine with an i7-47000MQ (2.4Ghz) processor and 12 Go of memory :

| 11.0.10  | `bootstrap`     | `arch-only`     | **Total**       | 1.8.0_282 | `bootstrap`     | `arch-only`       | **Total**       |
|----------|-----------------|-----------------|-----------------|-----------|-----------------|-----------------|-----------------|
| BellSoft | 42:19<br/>40:17 | 07:25<br/>07:37 | 49:44<br/>47:54 | BellSoft  |                 |                 |                 |
| Corretto | *Failure*       |                 |                 | Corretto  | *Failure*       |                 |                 |
| RedHat   |                 |                 |                 | RedHat    | 32:33<br/>30:38 | 08:04<br/>08:56 | 40:37<br/>39:34 |
| OpenJ9   | 42:04<br/>      | 16:40<br/>      | 58:44<br/>      | OpenJ9    | 38:45<br/>38:45 | 07:03<br/>05.19 | 57:08<br/>44:04 |
| OpenJDK  | 39:54<br/>      | 07:42<br/>      | 47:36<br/>      | OpenJDK   | 32:07<br/>      | 04:01<br/>      | 36:08<br/>      |
| Zulu     | 41:22<br/>      | 07:56<br/>      | 49:18<br/>      | Zulu      | 32:30<br/>32:40 | 06:50<br/>06:55 | 39:20<br/>39:35 |


## <span id="data_sharing">Data sharing</span>

This section supplements my writing from page [Data Sharing and Dotty on Windows](CDS.md).

An OpenJDK installation contains the file **`<install_dir>\lib\classlist`**. For instance we proceed as follows to check if data sharing is enabled in Oracle OpenJDK 11:

1. Command **`java.exe -version`** displays the OpenJDK version amongst other information; in particular, the last output line ends with
   - **`(build 11.0.10+9, mixed mode, sharing)`** if data sharing is enabled
   - **`(build 11.0.10+9, mixed mode)`** otherwise.
2. Command **`java.exe -Xshare:dump`** generates the 17.3 Mb Java shared archive **`<install_dir>\bin\server\classes.jsa`** from file **`<install_dir>\lib\classlist`**.
3. We go back to step 1 to verify that flag  **`sharing`** is present.


### <span id="graalvm">GraalVM OpenJDK 11</span> [**&#9650;**](#top)

[GraalVM][graalvm_org] is a universal virtual machine supporting the *interaction* between JVM-based languages like Java, Scala, Groovy, Kotlin, Clojure and native languages like C, C++, JavaScript, Python, R, Ruby.

<pre style="font-size:80%;">
<b>&gt; c:\opt\graalvm-ce-java11-21.0.0\bin\java -version</b>
openjdk version "11.0.10" 2021-01-19
OpenJDK Runtime Environment GraalVM CE 21.0.0 (build 11.0.10+8-jvmci-21.0-b06)
OpenJDK 64-Bit Server VM GraalVM CE 21.0.0 (build 11.0.10+8-jvmci-21.0-b06, mixed mode, sharing)
&nbsp;
<b>&gt; dir c:\opt\graalvm-ce-java11-21.0.0\bin\server | findstr jsa</b>
16.08.2020  08:41        17 563 648 classes.jsa
</pre>

We observe that [GraalVM][graalvm_org] is the only OpenJDK implementation to come with class sharing *enabled by default*.


### <span id="corretto">Corretto OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-corretto-11.0.10_9\bin\java -version</b>
openjdk version "11.0.9.1" 2020-11-04 LTS
OpenJDK Runtime Environment Corretto-11.0.9.12.1 (build 11.0.9.1+12-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.9.12.1 (build 11.0.9.1+12-LTS, mixed mode)

<b>&gt; c:\opt\jdk-corretto-11.0.10_9\bin\java -Xshare:dump</b>
[...]
Number of classes 1214
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-corretto-11.0.10_9\bin\server | findstr jsa</b>
30.10.2020  00:02        17 629 184 classes.jsa

<b>&gt; c:\opt\jdk-corretto-11.0.10_9\bin\java -version</b>
openjdk version "11.0.9.1" 2020-11-04 LTS
OpenJDK Runtime Environment Corretto-11.0.9.12.1 (build 11.0.9.1+12-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.9.12.1 (build 11.0.9.1+12-LTS, mixed mode, sharing)
</pre>

> **:mag_right:** Amazon provides online documentation specific to Corretto 11 (eg. [change Log][corretto_changes], [patches][corretto_patches] as well as Youtube videos (eg. Devoxx keynotes by [Arun Gupta][corretto_gupta] and [James Gosling][corretto_gosling]).

### <span id="liberica">Liberica OpenJDK 11</span> [**&#9650;**](#top)

[Liberica OpenJDK 11][bellsoft_downloads] is available both as a *"regular"* and as a *"lite"* version (no JavaFX modules, compressed modules). BellSoft currently provides binaries suitable for different hardware and OS combinations, eg. Windows x86_64 and Windows x86.

In the following we work with the *"regular"* version of Liberica OpenJDK 11.

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-liberica-11.0.9.1\bin\java -version</b>
openjdk version "11.0.9.1" 2020-11-04 LTS
OpenJDK Runtime Environment (build 11.0.9.1+1-LTS)
OpenJDK 64-Bit Server VM (build 11.0.9.1+1-LTS, mixed mode)

<b>&gt; c:\opt\jdk-liberica-11.0.9.1\bin\java -Xshare:dump</b>
[...]
Number of classes 1229
[...]
<b>&gt; dir c:\opt\jdk-liberica-11.0.9.1\bin\server | findstr jsa</b>
04.09.2020  19:48        17 760 256 classes.jsa

<b>&gt; c:\opt\jdk-liberica-11.0.9.1\bin\java -version</b>
openjdk version "11.0.9.1" 2020-11-04 LTS
OpenJDK Runtime Environment (build 11.0.9.1+1-LTS)
OpenJDK 64-Bit Server VM (build 11.0.9.1+1-LTS, mixed mode, sharing)
</pre>


### <span id="openj9">OpenJ9 OpenJDK 11</span> [**&#9650;**](#top)

Compared to the other OpenJDK distributions OpenJ9 JDK 11 provides advanced settings to manage shared data; it uses option [**`-Xshareclasses:<params>`**](https://www.eclipse.org/openj9/docs/xshareclasses/) instead of **`-Xshare:<param>`**.
> **:mag_right:** Execute **`java -Xshareclasses:help`** to list the settings.

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-openj9-11.0.9+11\bin\java -version</b>
openjdk version "11.0.9" 2020-10-20
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.9+11)
Eclipse OpenJ9 VM AdoptOpenJDK (build openj9-0.23.0, JRE 11 Windows 10 amd64-64-Bit Compressed References 20201022_795 (JIT enabled, AOT enabled)
OpenJ9   - 0394ef754
OMR      - 582366ae5
JCL      - 3b09cfd7e9 based on jdk-11.0.9+11)

[XXXXXXXXXX -Xshareclasses:name=<name> ##########]
</pre>


### <span id="oracle">Oracle OpenJDK 11</span> [**&#9650;**](#top)

Oracle OpenJDK is the [reference implementation][oracle_openjdk_project]; the other OpenJDK distributions are derived from it.
<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-11.0.9.1+1\bin\java -version</b>
openjdk version "11.0.9.1" 2020-11-04
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.9.1+1)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.9.1+1, mixed mode)

<b>&gt; c:\opt\jdk-11.0.9.1+1\bin\java -Xshare:dump</b>
[...]
Number of classes 1214
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-11.0.9.1+1\bin\server | findstr jsa</b>
30.10.2020  00:04        17 629 184 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-11.0.9.1+1\bin\java -version</b>
openjdk version "11.0.9.1" 2020-11-04
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.9.1+1)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.9.1+1, mixed mode, sharing)
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
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-redhat-11.0.10_9-1\bin\server | findstr jsa</b>
30.10.2020  10:09        17 760 256 classes.jsa

<b>&gt; c:\opt\jdk-redhat-11.0.10_9-1\bin\java -version</b>
openjdk version "11.0.10" 2021-01-19 LTS
OpenJDK Runtime Environment 18.9 (build 11.0.10+9-LTS)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.10+9-LTS, mixed mode, sharing)
</pre>


### <span id="sap">SapMachine OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-sapmachine-11.0.9.1\bin\java -version</b>
openjdk version "11.0.9.1" 2020-11-05 LTS
OpenJDK Runtime Environment SapMachine (build 11.0.9.1+1-LTS-sapmachine)
OpenJDK 64-Bit Server VM SapMachine (build 11.0.9.1+1-LTS-sapmachine, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-sapmachine-11.0.9.1\bin\java -Xshare:dump</b>
[...]
Number of classes 1214
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-sapmachine-11.0.9.1\bin\server | findstr jsa</b>
30.10.2020  09:39        17 629 184 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-sapmachine-11.0.9.1\bin\java -version</b>
openjdk version "11.0.9.1" 2020-11-05 LTS
OpenJDK Runtime Environment SapMachine (build 11.0.9.1+1-LTS-sapmachine)
OpenJDK 64-Bit Server VM SapMachine (build 11.0.9.1+1-LTS-sapmachine, mixed mode, sharing)
</pre>

> **:mag_right:** SAP provides [online documentation](https://github.com/SAP/SapMachine/wiki) specific to SapMachine 11, e.g. [Differences between SapMachine and OpenJDK](https://github.com/SAP/SapMachine/wiki/Differences-between-SapMachine-and-OpenJDK).

> **:mag_right:** SAP blog announcements:
> - [Re-Spin of OpenJDK/SapMachine 11.0.9 release](https://blogs.sap.com/2020/11/13/re-spin-of-openjdk-sapmachine-11.0.9-release/).


### <span id="trava">Trava OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-dcevm-11.0.9+1\bin\java -version</b>
openjdk version "11.0.9" 2020-10-20
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.8+1-202010241925)
Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.9+1-202010241925, mixed mode)

<b>&gt; c:\opt\jdk-dcevm-11.0.9+1\bin\java -Xshare:dump</b>
[...]
Number of classes 12629
[...]
total    :  18048312 [100.0% of total] out of  18219008 bytes [ 99.1% used
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-dcevm-11.0.9+1\bin\server | findstr jsa</b>
30.10.2020  09:26        17 956 864 classes.jsa

<b>&gt; c:\opt\jdk-dcevm-11.0.9+1\bin\java -version</b>
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.9+1-202010241925)
Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.9+1-202010241925, mixed mode, sharing)
</pre>

> **:mag_right:** [Trava OpenJDK](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases) is *not intended* to be used as 'main' JDK, since the integrated HotswapAgent is enabled by default and it uses serial GC by default. The default behaviour can be changed as follows:
> <pre style="font-size:80%;">
> <b>&gt; c:\opt\jdk-dcevm-11.0.9+1\bin\java -XX:+DisableHotswapAgent -XX:+UseConcMarkSweepGC -version</b>
> Dynamic Code Evolution 64-Bit Server VM warning: Option UseConcMarkSweepGC was deprecated in version 9.0 and will likely be removed in a future release.
> openjdk version "11.0.9" 2020-10-20
> OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.9+1-202010241925)
> Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.9+1-202010241925, mixed mode, sharing)
> </pre>
> Trava OpenJDK only supports the [serial and CMS garbage collectors](http://karunsubramanian.com/websphere/how-to-choose-the-correct-garbage-collector-java-generational-heap-and-garbage-collection-explained/) (ie. options `-XX:+UseParallelGC` and `-XX:+UseG1GC` are not supported).
> 
> Starting with <i>version 11.0.9</i> of the Trava OpenJDK the compiler option <code>-XX:+DisableHotswapAgent</code> is replaced
> by option <code>-XX:HotswapAgent:&lt;disabled|fatjar|core|external&gt;</code>.


### <span id="zulu">Zulu OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-zulu-11.0.9.1\bin\java -version</b>
openjdk version "11.0.9.1" 2020-11-04 LTS
OpenJDK Runtime Environment Zulu11.43+55-CA (build 11.0.9.1+1-LTS)
OpenJDK 64-Bit Server VM Zulu11.43+55-CA (build 11.0.9.1+1-LTS, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-zulu-11.0.9.1\bin\java -Xshare:dump</b>
[...]
Number of classes 1228
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-zulu-11.0.9.1\bin\server | findstr jsa</b>
30.10.2020  09:20        17 760 270 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-zulu-11.0.9.1\bin\java -version</b>
openjdk version "11.0.9.1" 2020-11-04 LTS
OpenJDK Runtime Environment Zulu11.43+55-CA (build 11.0.9.1+1-LTS)
OpenJDK 64-Bit Server VM Zulu11.43+55-CA (build 11.0.9.1+1-LTS, mixed mode, sharing)
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
<a href="https://github.com/corretto/corretto-11/releases" rel="external">amazon-corretto-11.0.10.9.1-windows-x64-jdk.zip</a>                <i>(177 MB)</i>
<a href="https://bell-sw.com/pages/downloads/#/java-11-lts">bellsoft-jdk11.0.9.1+1-windows-amd64.zip</a>                       <i>(187 MB)</i>
<a href="https://github.com/graalvm/graalvm-ce-builds/releases/tag/vm-21.0.0">graalvm-ce-java11-windows-amd64-21.0.0.zip</a>                     <i>(360 MB)</i>
<a href="https://developers.redhat.com/products/openjdk/download">java-11-openjdk-11.0.10.9-1.windows.redhat.x86_64.zip</a>          <i>(256 MB)</i>
<a href="https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases/latest">java11-openjdk-dcevm-windows.zip</a>                               <i>(187 MB)</i>
<a href="https://adoptopenjdk.net/?variant=openjdk11&jvmVariant=hotspot">OpenJDK11U-jdk_x64_windows_hotspot_11.0.9.1_1.zip</a>              <i>(190 MB)</i>
<a href="https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=openj9">OpenJDK11U-jdk_x64_windows_openj9_11.0.9_11_openj9-0.23.0.zip</a>  <i>(193 MB)</i>
<a href="https://github.com/SAP/SapMachine/releases/tag/sapmachine-11.0.10" rel="external">sapmachine-jdk-11.0.10_windows-x64_bin.zip</a>                     <i>(189 MB)</i>
<a href="https://www.azul.com/downloads/zulu-community/?version=java-11-lts" rel="external">zulu11.45.27-ca-jdk11.0.10-win_x64.zip</a>                         <i>(190 MB)</i>
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[amazon_aws]: https://aws.amazon.com/
[corretto_downloads]: https://github.com/corretto/corretto-11/releases
[corretto_relnotes]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/change-log.html
[azul_downloads]: https://www.azul.com/downloads/zulu/zulu-windows
[azul_relnotes]: https://docs.azul.com/zulu/zulurelnotes/index.htm#ZuluReleaseNotes/ReleaseDetails1129-834-726.htm
[azul_systems]: https://www.azul.com/
[bellsoft_about]: https://bell-sw.com/pages/about
[bellsoft_downloads]: https://bell-sw.com/pages/downloads/#/java-11-lts
[bellsoft_relnotes]: https://bell-sw.com/pages/liberica-release-notes-11.0.10/
[corretto_changes]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/change-log.html
[corretto_gosling]: https://www.youtube.com/watch?v=WuZk23O76Zk
[corretto_gupta]: https://www.youtube.com/watch?v=RLKC5nsiZXU
[corretto_patches]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/patches.html
[dotty]: https://dotty.epfl.ch/
[dotty_metaprogramming]: https://dotty.epfl.ch/docs/reference/metaprogramming/toc.html
[graalvm_downloads]: https://github.com/graalvm/graalvm-ce-builds/releases
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[graalvm_org]: https://www.graalvm.org/
[graalvm_relnotes]: https://www.graalvm.org/docs/release-notes/21_0/
[haskell_examples]: https://github.com/michelou/haskell-examples
[jmh_project]: https://openjdk.java.net/projects/code-tools/jmh/
[kotlin_examples]: https://github.com/michelou/kotlin-examples
[llvm_examples]: https://github.com/michelou/llvm-examples
[nodejs_examples]: https://github.com/michelou/nodejs-examples
[openj9_downloads]: https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=openj9
[openj9_news]: https://www.eclipse.org/openj9/oj9_whatsnew.html
[openj9_relnotes]: https://github.com/eclipse/openj9/releases/
[openjdk_jck]: https://openjdk.java.net/groups/conformance/JckAccess/
[openjdk_trademark]: https://openjdk.java.net/legal/openjdk-trademark-notice.html
[oracle]: https://www.oracle.com/
[oracle_openjdk_project]: https://openjdk.java.net/projects/jdk/11/
[oracle_openjdk_downloads]: https://adoptopenjdk.net/?variant=openjdk11&jvmVariant=hotspot
[oracle_openjdk_relnotes]: https://adoptopenjdk.net/release_notes.html?variant=openjdk11&jvmVariant=hotspot#jdk11_0_8
[redhat]: https://www.redhat.com/
[redhat_downloads]: https://developers.redhat.com/products/openjdk/download/
[sap_home]: https://www.sap.com/
[trava_downloads]: https://github.com/TravaOpenJDK/trava-jdk-11-dcevm
[trava_relnotes]: https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples
[unix_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
