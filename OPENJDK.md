# <span id="top">OpenJDK and Dotty on Windows</span> <span style="size:30%;"><a href="README.md">↩</a></span>

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

- [Running Dotty on Windows](README.md)
- [Building Dotty on Windows](BUILD.md)
- [Data Sharing and Dotty on Windows](CDS.md)
- OpenJDK and Dotty on Windows [**&#9660;**](#bottom)

[JMH][jmh_project], [Metaprogramming][dotty_metaprogramming], [GraalVM][graalvm_examples], [Haskell][haskell_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Node.js][nodejs_examples] and [TruffleSqueak][trufflesqueak_examples] are other trending topics we are currently monitoring.


## <span id="proj_deps">Project dependencies</span>

This project depends on several external software for the **Microsoft Windows** platform:

- [BellSoft OpenJDK 11][bellsoft_downloads] from [BellSoft][bellsoft_about] ([*release notes*][bellsoft_relnotes]).
- [Corretto OpenJDK 11][amazon_corretto_downloads] from [Amazon][amazon_aws] ([*release notes*][amazon_corretto_relnotes]).
- [GraalVM OpenJDK 11][graalvm_downloads] from [Oracle] ([*release notes*][graalvm_relnotes]).
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

For instance our development environment looks as follows (*October 2020*) <sup id="anchor_02">[[2]](#footnote_02)</sup>:

<pre style="font-size:80%;">
C:\opt\jdk-11.0.8+10\                 <i>(297 MB)</i>
C:\opt\jdk-bellsoft-11.0.8-lite\      <i>( 85 MB)</i>
C:\opt\jdk-corretto-11.0.8_10\        <i>(290 MB)</i>
C:\opt\jdk-dcevm-11.0.8+1\            <i>(295 MB)</i>
C:\opt\jdk-graalvm-ce-java11-20.2.0\  <i>(731 MB)</i>
C:\opt\jdk-openj9-11.0.8+10\          <i>(295 MB)</i>
C:\opt\jdk-redhat-11.0.8.10\          <i>( 63 MB)</i>
C:\opt\jdk-sapmachine-11.0.8\         <i>(288 MB)</i>
C:\opt\jdk-zulu-11.0.8\               <i>(299 MB)</i>
</pre>

## Data sharing

This section supplements my writing from page [Data Sharing and Dotty on Windows](CDS.md).

An OpenJDK installation contains the file **`<install_dir>\lib\classlist`**. For instance we proceed as follows to check if data sharing is enabled in Oracle OpenJDK 11:

1. Command **`java.exe -version`** displays the OpenJDK version amongst other information; in particular, the last output line ends with
   - **`(build 11.0.8+10-LTS, mixed mode, sharing)`** if data sharing is enabled
   - **`(build 11.0.8+10-LTS, mixed mode)`** otherwise.
2. Command **`java.exe -Xshare:dump`** generates the 17.3 Mb Java shared archive **`<install_dir>\bin\server\classes.jsa`** from file **`<install_dir>\lib\classlist`**.
3. We go back to step 1 to verify that flag  **`sharing`** is present.


### <span id="bellsoft">BellSoft OpenJDK 11</span> [**&#9650;**](#top)

[BellSoft OpenJDK 11][bellsoft_downloads] (aka Liberica JDK) is available both as a *"regular"* and as a *"lite"* version (no JavaFX modules, compressed modules). BellSoft currently provides binaries suitable for different hardware and OS combinations, eg. Windows x86_64 and Windows x86.

In the following we work with the *"lite"* version of BellSoft OpenJDK 11.

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-bellsoft-11.0.8-lite\bin\java -version</b>
openjdk version "11.0.8" 2020-07-14 LTS
OpenJDK Runtime Environment (build 11.0.8+10-LTS)
OpenJDK 64-Bit Server VM (build 11.0.8+10-LTS, mixed mode)

<b>&gt; c:\opt\jdk-bellsoft-11.0.8-lite\bin\java -Xshare:dump</b>
[...]
Number of classes 1229
[...]
<b>&gt; dir c:\opt\jdk-bellsoft-11.0.8-lite\bin\server | findstr jsa</b>
04.09.2020  19:48        17 760 256 classes.jsa

<b>&gt; c:\opt\jdk-bellsoft-11.0.8-lite\bin\java -version</b>
openjdk version "11.0.8" 2020-07-14 LTS
OpenJDK Runtime Environment (build 11.0.8+10-LTS)
OpenJDK 64-Bit Server VM (build 11.0.8+10-LTS, mixed mode, sharing)
</pre>

### <span id="graalvm">GraalVM OpenJDK 11</span> [**&#9650;**](#top)

[GraalVM][graalvm_org] is a universal virtual machine supporting the *interaction* between JVM-based languages like Java, Scala, Groovy, Kotlin, Clojure and native languages like C, C++, JavaScript, Python, R, Ruby.

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-graalvm-ce-java11-20.2.0\bin\java -version</b>
openjdk version "11.0.8" 2020-07-14
OpenJDK Runtime Environment GraalVM CE 20.2.0 (build 11.0.8+10-jvmci-20.2-b03)
OpenJDK 64-Bit Server VM GraalVM CE 20.2.0 (build 11.0.8+10-jvmci-20.2-b03, mixed mode, sharing)
&nbsp;
<b>&gt; dir c:\opt\jdk-graalvm-ce-java11-20.2.0\bin\server | findstr jsa</b>
16.08.2020  08:41        17 563 648 classes.jsa
</pre>

We observe that [GraalVM][graalvm_org] is the only OpenJDK implementation to come with class sharing *enabled by default*.

### <span id="corretto">Corretto OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-corretto-11.0.8_10\bin\java -version</b>
openjdk version "11.0.8" 2020-07-14 LTS
OpenJDK Runtime Environment Corretto-11.0.8.10.1 (build 11.0.8+10-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.8.10.1 (build 11.0.8+10-LTS, mixed mode)

<b>&gt; c:\opt\jdk-corretto-11.0.8_10\bin\java -Xshare:dump</b>
[...]
Number of classes 1214
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-corretto-11.0.8_10\bin\server | findstr jsa</b>
19.07.2020  00:02        17 629 184 classes.jsa

<b>&gt; c:\opt\jdk-corretto-11.0.8_10\bin\java -version</b>
openjdk version "11.0.8" 2020-07-14 LTS
OpenJDK Runtime Environment Corretto-11.0.8.10.1 (build 11.0.8+10-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.8.10.1 (build 11.0.8+10-LTS, mixed mode, sharing)
</pre>

> **:mag_right:** Amazon provides online documentation specific to Corretto 11 (eg. [change Log][corretto_changes], [patches][corretto_patches] as well as Youtube videos (eg. Devoxx keynotes by [Arun Gupta][corretto_gupta] and [James Gosling][corretto_gosling]).


### OpenJ9 OpenJDK 11

Compared to the other OpenJDK distributions OpenJ9 JDK 11 provides advanced settings to manage shared data; it uses option [**`-Xshareclasses:<params>`**](https://www.eclipse.org/openj9/docs/xshareclasses/) instead of **`-Xshare:<param>`**.
> **:mag_right:** Execute **`java -Xshareclasses:help`** to list the settings.

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-openj9-11.0.8+10\bin\java -version</b>
openjdk version "11.0.8" 2020-07-14
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.8+10)
Eclipse OpenJ9 VM AdoptOpenJDK (build openj9-0.21.0, JRE 11 Windows 10 amd64-64-Bit Compressed References 20200715_679 (JIT enabled, AOT enabled)
OpenJ9   - 34cf4c075
OMR      - 113e54219
JCL      - 95bb504fbb based on jdk-11.0.8+10)

[XXXXXXXXXX -Xshareclasses:name=<name> ##########]
</pre>


### <span id="oracle">Oracle OpenJDK 11</span> [**&#9650;**](#top)

Oracle OpenJDK is the [reference implementation][oracle_openjdk_project]; the other OpenJDK distributions are derived from it.
<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-11.0.8+10\bin\java -version</b>
openjdk version "11.0.8" 2020-07-14
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.8+10)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.8+10, mixed mode)

<b>&gt; c:\opt\jdk-11.0.8+10\bin\java -Xshare:dump</b>
[...]
Number of classes 1214
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-11.0.8+10\bin\server | findstr jsa</b>
19.07.2020  00:04        17 629 184 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-11.0.8+10\bin\java -version</b>
openjdk version "11.0.8" 2020-07-14
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.8+10)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 11.0.8+10, mixed mode, sharing)
</pre>


### <span id="redhat">RedHat OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-redhat-11.0.8.10\bin\java -version</b>
openjdk version "11.0.7" 2020-04-14 LTS
OpenJDK Runtime Environment 18.9 (build 11.0.7+10-LTS)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.7+10-LTS, mixed mode)

<b>&gt; c:\opt\jdk-redhat-11.0.7.10\bin\java -Xshare:dump</b>
[...]
Number of classes 1265
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-redhat-11.0.7.10\bin\server | findstr jsa</b>
28.04.2020  16:21        15 073 280 classes.jsa

<b>&gt; c:\opt\jdk-redhat-11.0.7.10\bin\java -version</b>
openjdk version "11.0.7" 2020-04-14 LTS
OpenJDK Runtime Environment 18.9 (build 11.0.7+10-LTS)
OpenJDK 64-Bit Server VM 18.9 (build 11.0.7+10-LTS, mixed mode, sharing)
</pre>


### <span id="sap">SapMachine OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-sapmachine-11.0.8\bin\java -version</b>
openjdk version "11.0.8" 2020-07-15 LTS
OpenJDK Runtime Environment SapMachine (build 11.0.8+10-LTS-sapmachine)
OpenJDK 64-Bit Server VM SapMachine (build 11.0.8+10-LTS-sapmachine, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-sapmachine-11.0.8\bin\java -Xshare:dump</b>
[...]
Number of classes 1214
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-sapmachine-11.0.8\bin\server | findstr jsa</b>
19.07.2020  00:29        17 629 184 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-sapmachine-11.0.8\bin\java -version</b>
openjdk version "11.0.8" 2020-07-15 LTS
OpenJDK Runtime Environment SapMachine (build 11.0.8+10-LTS-sapmachine)
OpenJDK 64-Bit Server VM SapMachine (build 11.0.8+10-LTS-sapmachine, mixed mode, sharing)
</pre>

> **:mag_right:** SAP provides [online documentation](https://github.com/SAP/SapMachine/wiki) specific to SapMachine 11, e.g. [Differences between SapMachine and OpenJDK](https://github.com/SAP/SapMachine/wiki/Differences-between-SapMachine-and-OpenJDK).


### <span id="trava">Trava OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-dcevm-11.0.8+1\bin\java -version</b>
Starting HotswapAgent 'c:\opt\jdk-dcevm-11.0.8+1\lib\hotswap\hotswap-agent.jar'
HOTSWAP AGENT: 10:28:40.841 INFO [...]
HOTSWAP AGENT: 10:28:41.089 INFO [...]
openjdk version "11.0.8" 2020-07-14
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.8+1-202007270708)
Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.8+1-202007270708, mixed mode)

<b>&gt; c:\opt\jdk-dcevm-11.0.8+1\bin\java -Xshare:dump</b>
[...]
Number of classes 12629
[...]
total    :  18048312 [100.0% of total] out of  18219008 bytes [ 99.1% used
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-dcevm-11.0.8+1\bin\server | findstr jsa</b>
04.09.2020  23:48        18 022 400 classes.jsa

<b>&gt; c:\opt\jdk-dcevm-11.0.8+1\bin\java -version</b>
Starting HotswapAgent 'c:\opt\jdk-dcevm-11.0.8+1\lib\hotswap\hotswap-agent.jar'
HOTSWAP AGENT: 10:31:03.941 INFO [...]
HOTSWAP AGENT: 10:31:04.189 INFO [...]
openjdk version "11.0.8" 2020-07-14
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.8+1-202007270708)
Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.8+1-202007270708, mixed mode, sharing)
</pre>

> **:mag_right:** [Trava OpenJDK](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases) is *not intended* to be used as 'main' JDK, since the integrated HotswapAgent is enabled by default and it uses serial GC by default. The default behaviour can be changed as follows:
> <pre style="font-size:80%;">
> <b>&gt; c:\opt\jdk-dcevm-11.0.8+1\bin\java -XX:+DisableHotswapAgent -XX:+UseConcMarkSweepGC -version</b>
> Dynamic Code Evolution 64-Bit Server VM warning: Option UseConcMarkSweepGC was deprecated in version 9.0 and will likely be removed in a future release.
> openjdk version "11.0.8" 2020-07-14
> OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.8+1-202007270708)
> Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.8+1-202007270708, mixed mode, sharing)
> </pre>
> Trava OpenJDK only supports the [serial and CMS garbage collectors](http://karunsubramanian.com/websphere/how-to-choose-the-correct-garbage-collector-java-generational-heap-and-garbage-collection-explained/) (ie. options `-XX:+UseParallelGC` and `-XX:+UseG1GC` are not supported).


### <span id="zulu">Zulu OpenJDK 11</span> [**&#9650;**](#top)

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-zulu-11.0.8\bin\java -version</b>
openjdk version "11.0.8" 2020-07-14 LTS
OpenJDK Runtime Environment Zulu11.41+23-CA (build 11.0.8+10-LTS)
OpenJDK 64-Bit Server VM Zulu11.41+23-CA (build 11.0.8+10-LTS, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-zulu-11.0.8\bin\java -Xshare:dump</b>
[...]
Number of classes 1228
[...]
<b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/dir">dir</a> c:\opt\jdk-zulu-11.0.8\bin\server | findstr jsa</b>
04.09.2020  23:51        17 760 256 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-zulu-11.0.8\bin\java -version</b>
openjdk version "11.0.8" 2020-07-14 LTS
OpenJDK Runtime Environment Zulu11.41+23-CA (build 11.0.8+10-LTS)
OpenJDK 64-Bit Server VM Zulu11.41+23-CA (build 11.0.8+10-LTS, mixed mode, sharing)
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

<b name="footnote_01" tooltip="[1]">[1]</b> ***JCK Compliance** (2018-04-06)* [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
The JCK is a proprietary test suite, <a href="https://openjdk.java.net/groups/conformance/JckAccess/index.html" rel="external">accessible under license from Oracle</a>.<br/>
The role of the JCK is not to determine <i>quality</i>, but rather to provide a binary indication of compatibility with the Java SE specification. As such, the JCK only tests functional behaviour, and only such functional behaviour that is given in the Java specification.<br/><i>(see <a href="https://github.com/AdoptOpenJDK/TSC/issues/19">issue 19</a> from <a href="https://github.com/AdoptOpenJDK/TSC">OpenJDK TSC</a>)</i>
</p>

<b name="footnote_02">[2]</b> ***Downloads*** [↩](#anchor_02)

<p style="margin:0 0 1em 20px;">
In our case we downloaded the following installation files (<a href="#proj_deps">see section 1</a>):
</p>
<pre style="margin:0 0 1em 20px; font-size:80%;">
<a href="https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html" rel="external">amazon-corretto-11.0.8.10.1-windows-x64-jdk.zip</a>                <i>(177 MB)</i>
<a href="https://bell-sw.com/pages/downloads/#/java-11-lts">bellsoft-jdk11.0.8+10-windows-amd64-lite.zip</a>                   <i>( 69 MB)</i>
<a href="https://github.com/graalvm/graalvm-ce-builds/releases/tag/vm-20.2.0">graalvm-ce-java11-windows-amd64-20.2.0.zip</a>                     <i>(360 MB)</i>
<a href="https://developers.redhat.com/products/openjdk/download">java-11-openjdk-11.0.8.10-2.windows.redhat.x86_64.zip</a>          <i>(235 MB)</i>
<a href="https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases/latest">java11-openjdk-dcevm-windows.zip</a>                               <i>(187 MB)</i>
<a href="https://adoptopenjdk.net/?variant=openjdk11&jvmVariant=hotspot">OpenJDK11U-jdk_x64_windows_hotspot_11.0.8_10.zip</a>               <i>(190 MB)</i>
<a href="https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=openj9">OpenJDK11U-jdk_x64_windows_openj9_11.0.8_10_openj9-0.21.0.zip</a>  <i>(193 MB)</i>
<a href="https://sap.github.io/SapMachine/" rel="external">sapmachine-jdk-11.0.8_windows-x64_bin.zip</a>                      <i>(187 MB)</i>
<a href="https://www.azul.com/downloads/zulu-community/?version=java-11-lts" rel="external">zulu11.41.23-ca-jdk11.0.8-win_x64.zip</a>                          <i>(188 MB)</i>
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/October 2020* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[amazon_aws]: https://aws.amazon.com/
[amazon_corretto_downloads]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html
[amazon_corretto_relnotes]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/change-log.html
[azul_downloads]: https://www.azul.com/downloads/zulu/zulu-windows
[azul_relnotes]: https://docs.azul.com/zulu/zulurelnotes/index.htm#ZuluReleaseNotes/ReleaseDetails1129-834-726.htm
[azul_systems]: https://www.azul.com/
[bellsoft_about]: https://bell-sw.com/pages/about
[bellsoft_downloads]: https://bell-sw.com/pages/downloads/#/java-11-lts
[bellsoft_relnotes]: https://bell-sw.com/pages/liberica-release-notes-11.0.8/
[corretto_changes]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/change-log.html
[corretto_gosling]: https://www.youtube.com/watch?v=WuZk23O76Zk
[corretto_gupta]: https://www.youtube.com/watch?v=RLKC5nsiZXU
[corretto_patches]: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/patches.html
[dotty]: https://dotty.epfl.ch/
[dotty_metaprogramming]: https://dotty.epfl.ch/docs/reference/metaprogramming/toc.html
[graalvm_downloads]: https://github.com/graalvm/graalvm-ce-builds/releases
[graalvm_examples]: https://github.com/michelou/graalvm-examples
[graalvm_org]: https://www.graalvm.org/
[graalvm_relnotes]: https://www.graalvm.org/docs/release-notes/20_1/
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
