# <span id="top">OpenJDK and Dotty on Windows</span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    <a href="http://openjdk.java.net/faq/">OpenJDK</a> is an open-source project initiated by Oracle in 2010. Java 8 is the first LTS version of Java to be released <i>both</i> as a commercial product (<a href="https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html">Oracle Java SE 8 </a>) and as an open-source product (<a href="https://adoptopenjdk.net/?variant=openjdk8&jvmVariant=hotspot">Oracle OpenJDK 8</a>).<br/>In the following we focus on OpenJDK 11, the current LTS version of Java.
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

- [BellSoft OpenJDK 11](https://bell-sw.com/pages/java-11.0.2/) from [BellSoft](https://bell-sw.com/pages/about).
- [DCEVM OpenJDK 11](https://github.com/TravaOpenJDK/trava-jdk-11-dcevm) from [Travis](https://travis-ci.com/).
- [OpenJ9 OpenJDK 11](https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=openj9) from [IBM Eclipse](https://www.ibm.com/developerworks/rational/library/nov05/cernosek/index.html).
- [Oracle OpenJDK 11](https://adoptopenjdk.net/?variant=openjdk11&jvmVariant=hotspot) from [Oracle](https://www.oracle.com/).
- [RedHat OpenJDK 11](https://developers.redhat.com/products/openjdk/download/) from [RedHat](https://www.redhat.com/).
- [SapMachine OpenJDK 11](https://sap.github.io/SapMachine/) from [SAP](https://www.sap.com/).
- [Zulu OpenJDK 11](https://www.azul.com/downloads/zulu/zulu-windows) from [Azul Systems](https://www.azul.com/).
- *(to come)* [Corretto OpenJDK](https://aws.amazon.com/corretto/) from [Amazon](https://aws.amazon.com/) (only version 8, version 11 planned for April 2019)

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a a [Zip archive](https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/) rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [**`/opt/`**](http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html) directory on Unix).

For instance our development environment looks as follows (*February 2019*):

<pre style="font-size:80%;">
C:\opt\jdk-11.0.2\
C:\opt\jdk-bellsoft-11.0.2\
C:\opt\jdk-dcevm-11.0.1\
C:\opt\jdk-openj9-11.0.2\
C:\opt\jdk-redhat-11.0.2\
C:\opt\jdk-sapmachine-11.0.2\
C:\opt\jdk-zulu-11.0.2\
</pre>

## Data sharing

This section supplements my writing [Data Sharing and Dotty on Windows](CDS.md).

An OpenJDK installation contains the file **`<install_dir>\lib\classlist`**. For instance we proceed as follows to check if data sharing is enabled in Oracle OpenJDK 11:

1. Command **`java.exe -version`** displays the OpenJDK version amongst other information; in particular, last displayed line ends with  **`(build 11.0.2+9-LTS, mixed mode, sharing)`** if data sharing is enabled, with **`(build 11.0.2+9-LTS, mixed mode)`** otherwise.
2. Command **`java.exe -Xshare:dump`** generates the 17.3 Mb Java shared archive **`<install_dir>\bin\server\classes.jsa`** from file **`<install_dir>\lib\classlist`**.
3. We repeat step 1 to verify that the **`sharing`** flag is present.


### BellSoft OpenJDK 11

<pre style="font-size:80%;">
<b>&gt;</b> c:\opt\jdk-bellsoft-11.0.2-lite\bin\java -version
openjdk version "11.0.2-BellSoft" 2018-10-16
OpenJDK Runtime Environment (build 11.0.2-BellSoft+7)
OpenJDK 64-Bit Server VM (build 11.0.2-BellSoft+7, mixed mode)

<b>&gt;</b> c:\opt\jdk-bellsoft-11.0.2-lite\bin\java -Xshare:dump
[...]
<b>&gt;</b> dir c:\opt\jdk-11.0.2\bin\server | findstr jsa
25.01.2019  23:27        18 153 472 classes.jsa

<b>&gt;</b> c:\opt\jdk-bellsoft-11.0.2-lite\bin\java -version
openjdk version "11.0.2-BellSoft" 2018-10-16
OpenJDK Runtime Environment (build 11.0.2-BellSoft+7)
OpenJDK 64-Bit Server VM (build 11.0.2-BellSoft+7, mixed mode, sharing)
</pre>


### DCEVM OpenJDK 11

<pre style="font-size:80%;">
<b>&gt;</b> c:\opt\jdk-dcevm-11.0.1\bin\java -version
Starting HotswapAgent 'c:\opt\jdk-dcevm-11.0.1\lib\hotswap\hotswap-agent.jar'
HOTSWAP AGENT: 13:13:46.677 INFO [...]
HOTSWAP AGENT: 13:13:47.328 INFO [...]
openjdk version "11.0.1.6" 2018-12-16
OpenJDK Runtime Environment AdoptOpenJDK (build 11.0.1.6+7-201901011603)
Dynamic Code Evolution 64-Bit Server VM AdoptOpenJDK (build 11.0.1.6+7-201901011603, mixed mode)

<b>&gt;</b> c:\opt\jdk-dcevm-11.0.1\bin\java -Xshare:dump
Starting HotswapAgent 'c:\opt\jdk-dcevm-11.0.1\lib\hotswap\hotswap-agent.jar'
narrow_klass_base = 0x0000000800000000, narrow_klass_shift = 3
[...]
Number of classes 1821
    instance classes   =  1673
    obj array classes  =   140
    type array classes =     8
Updating ConstMethods ... done.
#
# A fatal error has been detected by the Java Runtime Environment:
#
#  Internal Error (c:/Users/travis/build/TravaOpenJDK/trava-jdk-11-dcevm/openjdk-build/workspace/build/src/src/hotspot/share/memory/metaspaceShared.cpp:1624), pid=280208, tid=291128
#  guarantee(ik->loader_type() != 0) failed: Class loader type must be set for this class com/sun/proxy/$Proxy0
#
# JRE version: OpenJDK Runtime Environment (11.0.1.6+7) (build 11.0.1.6+7-201901011603)
# Java VM: Dynamic Code Evolution 64-Bit Server VM (11.0.1.6+7-201901011603, interpreted mode, compressed oops, serial gc, windows-amd64)
# No core dump will be written. Minidumps are not enabled by default on client versions of Windows
#
# An error report file with more information is saved as:
# W:\dotty-batch-files\hs_err_pid280208.log
#
# If you would like to submit a bug report, please visit:
#   https://github.com/AdoptOpenJDK/openjdk-build/issues
#
</pre>


### OpenJ9 OpenJDK 11

Compared to the other OpenJDK distributions OpenJ9 JDK 11 provides advanced settings to manage shared data; it uses option [**`-Xshareclasses:<params>`**](https://www.eclipse.org/openj9/docs/xshareclasses/) instead of **`-Xshare:<param>`**.
> **:mag_right:** Execute **`java -Xshareclasses:help`** to list the settings.

<pre style="font-size:80%;">
&gt; c:\opt\jdk-openj9-11.0.2\bin\java -version
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
&gt; c:\opt\jdk-11.0.2\bin\java -version
java version "11.0.2" 2019-01-15 LTS
Java(TM) SE Runtime Environment 18.9 (build 11.0.2+9-LTS)
Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.2+9-LTS, mixed mode)

&gt; c:\opt\jdk-11.0.2\bin\java -Xshare:dump
[...]
&gt; dir c:\opt\jdk-11.0.2\bin\server | findstr jsa
17.12.2018  13:03        18 153 472 classes.jsa

&gt; c:\opt\jdk-11.0.2\bin\java -version
java version "11.0.2" 2019-01-15 LTS
Java(TM) SE Runtime Environment 18.9 (build 11.0.2+9-LTS)
Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.2+9-LTS, mixed mode, sharing)
</pre>


### RedHat OpenJDK 11

<pre style="font-size:80%;">
<b>&gt;</b> c:\opt\jdk-redhat-11.0.2\bin\java -version
openjdk version "11.0.2-redhat" 2019-01-15 LTS
OpenJDK Runtime Environment (build 11.0.2-redhat+7-LTS)
OpenJDK 64-Bit Server VM (build 11.0.2-redhat+7-LTS, mixed mode)

<b>&gt;</b> c:\opt\jdk-redhat-11.0.2\bin\java -Xshare:dump
[...]
Number of classes 1270
[...]
<b>&gt;</b> dir c:\opt\jdk-redhat-11.0.2\bin\server | findstr jsa
07.02.2019  22:51        18 153 472 classes.jsa

<b>&gt;</b> c:\opt\jdk-redhat-11.0.2\bin\java -version
openjdk version "11.0.2-redhat" 2019-01-15 LTS
OpenJDK Runtime Environment (build 11.0.2-redhat+7-LTS)
OpenJDK 64-Bit Server VM (build 11.0.2-redhat+7-LTS, mixed mode, sharing)
</pre>


### SapMachine OpenJDK 11

<pre style="font-size:80%;">
<b>&gt;</b> c:\opt\jdk-sapmachine-11.0.2\bin\java -version
openjdk version "11.0.2" 2019-01-16 LTS
OpenJDK Runtime Environment (build 11.0.2+0-LTS-sapmachine)
OpenJDK 64-Bit Server VM (build 11.0.2+0-LTS-sapmachine, mixed mode)
&nbsp;
<b>&gt;</b> c:\opt\jdk-sapmachine-11.0.2\bin\java -Xshare:dump
[...]
<b>&gt;</b> dir c:\opt\jdk-sapmachine-11.0.2\bin\server | findstr jsa
02.01.2019  11:53        17 956 864 classes.jsa
&nbsp;
<b>&gt;</b> c:\opt\jdk-sapmachine-11.0.2\bin\java -version
openjdk version "11.0.2" 2019-01-16 LTS
OpenJDK Runtime Environment (build 11.0.2+0-LTS-sapmachine)
OpenJDK 64-Bit Server VM (build 11.0.2+0-LTS-sapmachine, mixed mode, sharing)
</pre>


### Zulu OpenJDK 11

<pre style="font-size:80%;">
&gt; c:\opt\jdk-zulu-11.0.2\bin\java -version
openjdk version "11.0.2" 2019-01-15 LTS
OpenJDK Runtime Environment Zulu11.29+3-CA (build 11.0.2+7-LTS)
OpenJDK 64-Bit Server VM Zulu11.29+3-CA (build 11.0.2+7-LTS, mixed mode)
&nbsp;
&gt; c:\opt\jdk-zulu-11.0.2\bin\java -Xshare:dump
[...]
&gt; dir c:\opt\jdk-zulu11.2.3-11.0.1\bin\server | findstr jsa
24.12.2018  18:01        18 153 472 classes.jsa
&nbsp;
&gt; c:\opt\jdk-zulu-11.0.2\bin\java -version
openjdk version "11.0.2" 2019-01-15 LTS
OpenJDK Runtime Environment Zulu11.29+3-CA (build 11.0.2+7-LTS)
OpenJDK 64-Bit Server VM Zulu11.29+3-CA (build 11.0.2+7-LTS, mixed mode, sharing)
</pre>


## Related reading

#### 2016
<dl>
  <dt><a href="https://www.slideshare.net/DanHeidinga/j9-under-the-hood-of-the-next-open-source-jvm">IBM</a>:<a name="ref_01">&nbsp;</a>OpenJ9: Under the hood of the next open source JVM</dt>
  <dd><i>by Dan Heidinga (2016-09-21)</i><br/>Dan Heidinga gives a description of how bytecodes are loaded into the J9VM and how bytecode execution occurs, plus IBM's plans to open source J9.</dd>
</dl>

#### 2017

<dl>
  <dt><a href="https://www.slideshare.net/DanHeidinga/javaone-2017-eclipse-openj9-under-the-hood-of-the-jvm">JavaOne 2017</a>:<a name="ref_02">&nbsp;</a>Eclipse OpenJ9: Under the hood of the JVM</dt>
  <dd><i>by Dan Heidinga (2017-10-10)</i><br/>Dan Heiding presents an updated version of my "OpenJ9: Under the hood of the next open source JVM" that covers where it was open sourced (github.com/eclipse/openj9), how to build it, and then deep dives into the ROM/RAM divide before touching on interpreter, JIT and AOT.</dd>
</dl>

#### 2018

<dl>
  <dt><a href="https://developer.ibm.com/tutorials/j-class-sharing-openj9/">IBM Developer</a>:<a name="ref_03">&nbsp;</a>Class sharing in Eclipse OpenJ9</dt>
  <dd><i>by Ben Corrie, Hang Shao (2018-06-06)</i><br/>Reduce your memory footprint and improve startup performance with the shared class feature.</dd>
</dl>

<!--
## Footnotes

<a name="footnote_01">[1]</a> ***2018-08-17*** [↩](#anchor_01)

<div style="margin:0 0 1em 20px;">
</div>
-->
***

*[mics](http://lampwww.epfl.ch/~michelou/)/February 2019* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>
