# <span id="top">OpenJDK and Dotty on Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:80px;">
    <a href="http://dotty.epfl.ch/"><img style="border:0;width:80px;" src="docs/dotty.png" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    <a href="http://openjdk.java.net/faq/">OpenJDK</a> is an open-source project initiated by Oracle in 2010. Java 8 is the first LTS version of Java to be released <i>both</i> as a commercial product (<a href="https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html">Oracle Java SE 8 </a>) and as an open-source product (<a href="https://adoptopenjdk.net/?variant=openjdk8&jvmVariant=hotspot">Oracle OpenJDK 8</a>).<br/>In the following we focus on <a href="https://jdk.java.net/11/">OpenJDK 11</a>, the current LTS version of Java.
  </td>
  </tr>
</table>

This page is part of a series of topics related to [Dotty](http://dotty.epfl.ch/) on Windows:

- [Running Dotty on Windows](README.md)
- [Building Dotty on Windows](DRONE.md)
- [Data Sharing and Dotty on Windows](CDS.md)
- OpenJDK and Dotty on Windows [**&#9660;**](#bottom)


## Project dependencies

This project depends on several external software for the **Microsoft Windows** platform:

- [BellSoft OpenJDK 11](https://bell-sw.com/pages/java-11.0.2/) from [BellSoft](https://bell-sw.com/pages/about) ([*release notes*](https://bell-sw.com/pages/liberica-release-notes-11.0.2)). <!-- build 11.0.2-BellSoft+7 -->
- [Corretto OpenJDK 11](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html) from [Amazon](https://aws.amazon.com/) ([*release notes*](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/change-log.html)). <!-- build 11.0.2+9-LTS -->
- [OpenJ9 OpenJDK 11](https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=openj9) from [IBM Eclipse](https://www.ibm.com/developerworks/rational/library/nov05/cernosek/index.html). <!-- build 11.0.2+9 -->
- [Oracle OpenJDK 11](https://adoptopenjdk.net/?variant=openjdk11&jvmVariant=hotspot) from [Oracle](https://www.oracle.com/). <!-- build 11.0.2+9 -->
- [RedHat OpenJDK 11](https://developers.redhat.com/products/openjdk/download/) from [RedHat](https://www.redhat.com/). <!-- build 11.0.2-redhat+7-LTS (2019-02-07) -->
- [SapMachine OpenJDK 11](https://sap.github.io/SapMachine/) from [SAP](https://www.sap.com/). <!-- build 11.0.2+0-LTS-sapmachine -->
- [Trava OpenJDK 11](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm) from [Travis](https://travis-ci.com/) ([*release notes*](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases)). <!-- 11.0.1+8 (2019-03-16) -->
- [Zulu OpenJDK 11](https://www.azul.com/downloads/zulu/zulu-windows) from [Azul Systems](https://www.azul.com/) ([*release notes*](https://docs.azul.com/zulu/zulurelnotes/index.htm#ZuluReleaseNotes/ReleaseDetails1129-834-726.htm)). <!-- build 11.0.2+7-LTS -->

The above implementations of OpenJDK[&trade;](http://openjdk.java.net/legal/openjdk-trademark-notice.html) differ in several ways:

- they are tested and certified for [JCK](https://openjdk.java.net/groups/conformance/JckAccess/) <sup id="anchor_01">[[1]](#footnote_01)</sup> compliance excepted for Trava OpenJDK.
- they include different [backports](https://builds.shipilev.net/backports-monitor/) of fixes from OpenJDK 12 or newer (eg. [Corretto](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/patches.html)).
- they include additional modules (eg. Device IO API on Linux ARMv7) or integrate special tools (eg. HotswapAgent in [Trava](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm)).
- they support different sets of platform architectures (eg. [SapMachine](https://sap.github.io/SapMachine/) x64 only, [BellSoft](https://bell-sw.com/pages/liberica-release-notes-11.0.2) also Raspberry Pi 2 &amp; 3).


> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a a [Zip archive](https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/) rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [**`/opt/`**](http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) directory on Unix).

For instance our development environment looks as follows (*March 2019*):

<pre style="font-size:80%;">
C:\opt\jdk-11.0.2\
C:\opt\jdk-bellsoft-11.0.2\
C:\opt\jdk-corretto-11.0.2\
C:\opt\jdk-openj9-11.0.2\
C:\opt\jdk-redhat-11.0.2\
C:\opt\jdk-sapmachine-11.0.2\
C:\opt\jdk-trava-11.0.1\
C:\opt\jdk-zulu-11.0.2\
</pre>


## Data sharing

This section supplements my writing from page [Data Sharing and Dotty on Windows](CDS.md).

An OpenJDK installation contains the file **`<install_dir>\lib\classlist`**. For instance we proceed as follows to check if data sharing is enabled in Oracle OpenJDK 11:

1. Command **`java.exe -version`** displays the OpenJDK version amongst other information; in particular, last displayed line ends with  **`(build 11.0.2+9-LTS, mixed mode, sharing)`** if data sharing is enabled, with **`(build 11.0.2+9-LTS, mixed mode)`** otherwise.
2. Command **`java.exe -Xshare:dump`** generates the 17.3 Mb Java shared archive **`<install_dir>\bin\server\classes.jsa`** from file **`<install_dir>\lib\classlist`**.
3. We repeat step 1 to verify that the **`sharing`** flag is present.


### BellSoft OpenJDK 11

[BellSoft OpenJDK 11](https://bell-sw.com/pages/java-11.0.2/) (aka Liberica JDK) is available both as a *"regular"* and as a *"lite"* version (no JavaFX modules, compressed modules). BellSoft currently provides binaries suitable for different hardware and OS combinations, eg. Windows x86_64 and Windows x86.

In the following we work with the *"lite"* version of BellSoft OpenJDK 11.

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-bellsoft-11.0.2-lite\bin\java -version</b>
openjdk version "11.0.2-BellSoft" 2018-10-16
OpenJDK Runtime Environment (build 11.0.2-BellSoft+7)
OpenJDK 64-Bit Server VM (build 11.0.2-BellSoft+7, mixed mode)

<b>&gt; c:\opt\jdk-bellsoft-11.0.2-lite\bin\java -Xshare:dump</b>
[...]
Number of classes 1270
[...]
<b>&gt; dir c:\opt\jdk-11.0.2\bin\server | findstr jsa</b>
25.01.2019  23:27        18 153 472 classes.jsa

<b>&gt; c:\opt\jdk-bellsoft-11.0.2-lite\bin\java -version</b>
openjdk version "11.0.2-BellSoft" 2018-10-16
OpenJDK Runtime Environment (build 11.0.2-BellSoft+7)
OpenJDK 64-Bit Server VM (build 11.0.2-BellSoft+7, mixed mode, sharing)
</pre>


### Corretto OpenJDK 11

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-corretto-11.0.2_9\bin\java -version</b>
openjdk version "11.0.2" 2019-01-15 LTS
OpenJDK Runtime Environment Corretto-11.0.2.9.3 (build 11.0.2+9-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.2.9.3 (build 11.0.2+9-LTS, mixed mode)

<b>&gt; c:\opt\jdk-corretto-11.0.2_9\bin\java -Xshare:dump</b>
[...]
Number of classes 1257
[...]
<b>&gt; dir c:\opt\jdk-corretto-11.0.2_9\bin\server | findstr jsa</b>
15.02.2019  12:17        17 956 864 classes.jsa

<b>&gt; c:\opt\jdk-corretto-11.0.2_9\bin\java -version</b>
openjdk version "11.0.2" 2019-01-15 LTS
OpenJDK Runtime Environment Corretto-11.0.2.9.3 (build 11.0.2+9-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.2.9.3 (build 11.0.2+9-LTS, mixed mode, sharing)
</pre>

> **:mag_right:** Amazon provides online documentation specific to Corretto 11 (eg. [change Log](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/change-log.html), [patches](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/patches.html)) as well as Youtube videos (eg. Devoxx keynotes by [Arun Gupta](https://www.youtube.com/watch?v=RLKC5nsiZXU) and [James Gosling](https://www.youtube.com/watch?v=WuZk23O76Zk)).


### OpenJ9 OpenJDK 11

Compared to the other OpenJDK distributions OpenJ9 JDK 11 provides advanced settings to manage shared data; it uses option [**`-Xshareclasses:<params>`**](https://www.eclipse.org/openj9/docs/xshareclasses/) instead of **`-Xshare:<param>`**.
> **:mag_right:** Execute **`java -Xshareclasses:help`** to list the settings.

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-openj9-11.0.2\bin\java -version</b>
openjdk version "11.0.2" 2019-01-15
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.2+9)
Eclipse OpenJ9 VM AdoptOpenJDK (build openj9-0.12.0, JRE 11 Windows 10 amd64-64-Bit Compressed References 20190130_114 (JIT enabled, AOT enabled)
OpenJ9   - 04890c300
OMR      - d2f4534b
JCL      - 50b45cd160 based on jdk-11.0.2+8)

[XXXXXXXXXX -Xshareclasses:name=<name> ##########]
</pre>


### Oracle OpenJDK 11

Oracle OpenJDK is the [reference implementation](https://openjdk.java.net/projects/jdk/11/); the other OpenJDK distributions are derived from it.
<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-11.0.2\bin\java -version</b>
java version "11.0.2" 2019-01-15 LTS
Java(TM) SE Runtime Environment 18.9 (build 11.0.2+9-LTS)
Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.2+9-LTS, mixed mode)

<b>&gt; c:\opt\jdk-11.0.2\bin\java -Xshare:dump</b>
[...]
Number of classes 1272
[...]
<b>&gt; dir c:\opt\jdk-11.0.2\bin\server | findstr jsa</b>
17.12.2018  13:03        18 153 472 classes.jsa

<b>&gt; c:\opt\jdk-11.0.2\bin\java -version</b>
java version "11.0.2" 2019-01-15 LTS
Java(TM) SE Runtime Environment 18.9 (build 11.0.2+9-LTS)
Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.2+9-LTS, mixed mode, sharing)
</pre>


### RedHat OpenJDK 11

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-redhat-11.0.2\bin\java -version</b>
openjdk version "11.0.2-redhat" 2019-01-15 LTS
OpenJDK Runtime Environment (build 11.0.2-redhat+7-LTS)
OpenJDK 64-Bit Server VM (build 11.0.2-redhat+7-LTS, mixed mode)

<b>&gt; c:\opt\jdk-redhat-11.0.2\bin\java -Xshare:dump</b>
[...]
Number of classes 1270
[...]
<b>&gt; dir c:\opt\jdk-redhat-11.0.2\bin\server | findstr jsa</b>
07.02.2019  22:51        18 153 472 classes.jsa

<b>&gt; c:\opt\jdk-redhat-11.0.2\bin\java -version</b>
openjdk version "11.0.2-redhat" 2019-01-15 LTS
OpenJDK Runtime Environment (build 11.0.2-redhat+7-LTS)
OpenJDK 64-Bit Server VM (build 11.0.2-redhat+7-LTS, mixed mode, sharing)
</pre>


### SapMachine OpenJDK 11

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-sapmachine-11.0.2\bin\java -version</b>
openjdk version "11.0.2" 2019-01-16 LTS
OpenJDK Runtime Environment (build 11.0.2+0-LTS-sapmachine)
OpenJDK 64-Bit Server VM (build 11.0.2+0-LTS-sapmachine, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-sapmachine-11.0.2\bin\java -Xshare:dump</b>
[...]
Number of classes 1257
[...]
<b>&gt; dir c:\opt\jdk-sapmachine-11.0.2\bin\server | findstr jsa</b>
02.01.2019  11:53        17 956 864 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-sapmachine-11.0.2\bin\java -version</b>
openjdk version "11.0.2" 2019-01-16 LTS
OpenJDK Runtime Environment (build 11.0.2+0-LTS-sapmachine)
OpenJDK 64-Bit Server VM (build 11.0.2+0-LTS-sapmachine, mixed mode, sharing)
</pre>

> **:mag_right:** SAP provides [online documentation](https://github.com/SAP/SapMachine/wiki) specific to SapMachine 11, e.g. [Differences between SapMachine and OpenJDK](https://github.com/SAP/SapMachine/wiki/Differences-between-SapMachine-and-OpenJDK).


### Trava OpenJDK 11

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-trava-11.0.1\bin\java -version</b>
Starting HotswapAgent 'c:\opt\jdk-trava-11.0.1\lib\hotswap\hotswap-agent.jar'
HOTSWAP AGENT: 17:59:08.070 INFO [...]
HOTSWAP AGENT: 17:59:08.304 INFO [...]
openjdk version "11.0.1.6" 2018-12-16
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.1.6+8-201903160759)
Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.1.6+8-201903160759, mixed mode)

<b>&gt; c:\opt\jdk-trava-11.0.1\bin\java -Xshare:dump</b>
[...]
Number of classes 1268
[...]
total    :  18142072 [100.0% of total] out of  18415616 bytes [ 98.5% used]
<b>&gt; dir c:\opt\jdk-trava-11.0.1\bin\server | findstr jsa</b>
20.03.2019  16:17        18 481 152 classes.jsa

<b>&gt; c:\opt\jdk-trava-11.0.1\bin\java -version</b>
Starting HotswapAgent 'c:\opt\jdk-trava-11.0.1\lib\hotswap\hotswap-agent.jar'
HOTSWAP AGENT: 18:01:52.543 INFO [...]
HOTSWAP AGENT: 18:01:52.765 INFO [...]
openjdk version "11.0.1.6" 2018-12-16
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.1.6+8-201903160759)
Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.1.6+8-201903160759, mixed mode, sharing)
</pre>

> **:mag_right:** [Trava OpenJDK](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm/releases) is *not intended* to be used as 'main' JDK, since the integrated HotswapAgent is enabled by default and it uses serial GC by default. The default behaviour can be changed as follows:
> <pre>
> <b>&gt; java -XX:+DisableHotswapAgent -XX:+UseConcMarkSweepGC -version</b>
> Dynamic Code Evolution 64-Bit Server VM warning: Option UseConcMarkSweepGC\
>  was deprecated in version 9.0 and will likely be removed in a future release.
> openjdk version "11.0.1.6" 2018-12-16
> OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.1.6+8-201903160759)
> Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.1.6+8-201903160759, mixed mode, sharing)
> </pre>
> Trava OpenJDK only supports the [serial and CMS garbage collectors](http://karunsubramanian.com/websphere/how-to-choose-the-correct-garbage-collector-java-generational-heap-and-garbage-collection-explained/) (ie. options `-XX:+UseParallelGC` and `-XX:+UseG1GC` are not supported).


### Zulu OpenJDK 11

<pre style="font-size:80%;">
<b>&gt; c:\opt\jdk-zulu-11.0.2\bin\java -version</b>
openjdk version "11.0.2" 2019-01-15 LTS
OpenJDK Runtime Environment Zulu11.29+3-CA (build 11.0.2+7-LTS)
OpenJDK 64-Bit Server VM Zulu11.29+3-CA (build 11.0.2+7-LTS, mixed mode)
&nbsp;
<b>&gt; c:\opt\jdk-zulu-11.0.2\bin\java -Xshare:dump</b>
[...]
Number of classes 1271
[...]
<b>&gt; dir c:\opt\jdk-zulu11.2.3-11.0.1\bin\server | findstr jsa</b>
24.12.2018  18:01        18 153 472 classes.jsa
&nbsp;
<b>&gt; c:\opt\jdk-zulu-11.0.2\bin\java -version</b>
openjdk version "11.0.2" 2019-01-15 LTS
OpenJDK Runtime Environment Zulu11.29+3-CA (build 11.0.2+7-LTS)
OpenJDK 64-Bit Server VM Zulu11.29+3-CA (build 11.0.2+7-LTS, mixed mode, sharing)
</pre>


## Related reading

### 2016
<dl>
  <dt><a href="https://www.slideshare.net/DanHeidinga/j9-under-the-hood-of-the-next-open-source-jvm">IBM</a>:<a name="ref_01">&nbsp;</a>OpenJ9: Under the hood of the next open source JVM</dt>
  <dd><i>by Dan Heidinga (2016-09-21)</i><br/>Dan Heidinga gives a description of how bytecodes are loaded into the J9VM and how bytecode execution occurs, plus IBM's plans to open source J9.</dd>
</dl>

### 2017

<dl>
  <dt><a href="https://www.slideshare.net/DanHeidinga/javaone-2017-eclipse-openj9-under-the-hood-of-the-jvm">JavaOne 2017</a>:<a name="ref_02">&nbsp;</a>Eclipse OpenJ9: Under the hood of the JVM</dt>
  <dd><i>by Dan Heidinga (2017-10-10)</i><br/>Dan Heiding presents an updated version of my "OpenJ9: Under the hood of the next open source JVM" that covers where it was open sourced (github.com/eclipse/openj9), how to build it, and then deep dives into the ROM/RAM divide before touching on interpreter, JIT and AOT.</dd>
</dl>

### 2018

<dl>
  <dt><a href="https://developer.ibm.com/tutorials/j-class-sharing-openj9/">IBM Developer</a>:<a name="ref_03">&nbsp;</a>Class sharing in Eclipse OpenJ9</dt>
  <dd><i>by Ben Corrie, Hang Shao (2018-06-06)</i><br/>Reduce your memory footprint and improve startup performance with the shared class feature.</dd>
</dl>


## Footnotes

<a name="footnote_01">[1]</a> ***2018-04-06*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
The JCK is a proprietary test suite, <a href="http://openjdk.java.net/groups/conformance/JckAccess/index.html">accessible under license from Oracle</a>.<br/>
The role of the JCK is not to determine <i>quality</i>, but rather to provide a binary indication of compatibility with the Java SE specification. As such, the JCK only tests functional behaviour, and only such functional behaviour that is given in the Java specification.<br/><i>(see <a href="https://github.com/AdoptOpenJDK/TSC/issues/19">issue 19</a> from <a href="https://github.com/AdoptOpenJDK/TSC">OpenJDK TSC</a>)</i>
</p>

***

*[mics](http://lampwww.epfl.ch/~michelou/)/February 2019* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>
