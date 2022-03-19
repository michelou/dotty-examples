# <span id="top">Scala 3 Dependencies</span> <span style="size:25%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:60px;max-width:100px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:80px;" src="docs/images/dotty.png" alt="Dotty project" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This document presents changes in library dependencies for the Scala 3 software distributions.<br/>&nbsp;
  </td>
  </tr>
</table>

## <span id="intro">Introduction</span>

The [Scala 3](https://www.scala-lang.org/download/scala3.html) and [Scala 2](https://www.scala-lang.org/download/scala2.html) software distributions differ in several ways regarding their dependencies on external libraries. We enumerate here the main differences :
- Scala 3 depends on *many more* external libraries, introduced mainly with the new development of [`scaladoc`](https://docs.scala-lang.org/scala3/scaladoc.html).
- Scala 3 depends on [`compiler-interface`](https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface), the Scala incremental compiler library ([`Zinc`](https://mvnrepository.com/artifact/org.scala-sbt/zinc)), originally part of [`sbt`](https://www.scala-sbt.org/).
- Scala 3 depends on [`scala-library`](https://mvnrepository.com/artifact/org.scala-lang/scala-library), the Scala 2.13 standard library (mainly for compatibility with the [Scala 2 collection framework](https://docs.scala-lang.org/overviews/collections-2.13/introduction.html)).
- Depencencies *common* to both software distributions include [`jline`](https://github.com/jline/jline3#jline----) ([Scala REPL](https://docs.scala-lang.org/scala3/book/taste-repl.html)) and [`scala-asm`](https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm) ([JVM backend](https://dotty.epfl.ch/docs/internals/backend.html)).

> **:mag_right:** We observe a jump in the increases in size of the software distributions : 
> |  Version  | Release date | Zip archive | Installation |
> |:----------|:------------:|:-----------:|:------------:|
> |  [3.1.2](https://github.com/lampepfl/dotty/releases/tag/3.1.2-RC2) | Mar 2022 |   33.4 MB   |   35.3 MB    |
> |  [3.1.1](https://github.com/lampepfl/dotty/releases/tag/3.1.1)     | Jan 2022 |   33.3 MB   |   35.2 MB    |
> |  [3.1.0](https://github.com/lampepfl/dotty/releases/tag/3.1.0)     | Oct 2021 |   33.1 MB   |   35.0 MB    |
> |  [3.0.2](https://github.com/lampepfl/dotty/releases/tag/3.0.2)     | Sep 2021 |   31.2 MB   |   33.0 MB    |
> |  [3.0.1](https://github.com/lampepfl/dotty/releases/tag/3.0.1)     | Jul 2021 |   29.8 MB   |   33.0 MB    |
> |  [2.13.8](https://www.scala-lang.org/download/2.13.8.html)         | Jan 2022 |   22.6 MB   |   24.1 MB    |
> |  [2.13.7](https://www.scala-lang.org/download/2.13.7.html)         | Nov 2021 |   22.6 MB   |   24.1 MB    |
> |  [2.13.6](https://www.scala-lang.org/download/2.13.6.html)         | May 2021 |   22.3 MB   |   23.8 MB    |
> |  [2.12.15](https://www.scala-lang.org/download/2.12.15.html)       | Sep 2021 |   20.1 MB   |   21.5 MB    |

In the next sections we give more details on those dependencies for the three Scala distributions currently available, namely [3.1](#scala3_releases), [2.13](#scala213_releases) and [2.12](#scala212_releases).

## <span id="scala31_releases">Dependencies in Scala 3.1 Releases</span>

As mentioned in the introduction the Scala 3 distributions depend on *many* external libraries.

<table style="font-size:80%;">
<tr>
  <th style="padding:4px;min-width:115px;">Java Archive</th>
  <th style="padding:4px;">Current<br/>Version</th>
  <th style="padding:4px;"><a href="https://github.com/lampepfl/dotty/releases/tag/3.1.0">3.1.0</a><br/><span style="color:gray;">final</span></th>
  <th><a href="https://github.com/lampepfl/dotty/releases/tag/3.1.1">3.1.1</a><br/><span style="color:gray;">final</span></th>
  <th><a href="https://github.com/lampepfl/dotty/releases/tag/3.1.2-RC2">3.1.2</a><br/><span style="color:red;">RC2</span></th>
  <th><a href="https://mvnrepository.com/artifact/org.scala-lang/scala3-compiler">3.1.3</a><br/><span style="color:red;">RC1</span></th>
  <th><a href="https://mvnrepository.com/artifact/org.scala-lang/scala3-compiler">3.2.0</a><br/><span style="color:red;">RC1</span></th>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr4"><code>antlr-*</code></a><br/>(<a href="https://github.com/antlr/antlr4/releases">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr4/4.9.3"><b>4.9.3</b></a><br/><span style="color:gray;font-size:80%;">(Nov&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr/3.5.1">3.5.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr/3.5.1">3.5.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr4/4.7.2">4.7.2</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr4/4.7.2">4.7.2</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr4/4.7.2">4.7.2</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink"><code>autolink-*</code></a><br/>(<a href="https://github.com/robinst/autolink-java/releases">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.10.0"><b>0.10.0</b></a><br/><span style="color:gray;font-size:80%;">(Jul 2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface"><code>compiler-interface</code></a><br/>(<a href="https://github.com/sbt/zinc/releases" rel="external">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.6.1"><b>1.6.1</b></a><br/><span style="color:gray;font-size:80%;">(Jan&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.3.5">1.3.5</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.3.5">1.3.5</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.3.5">1.3.5</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.3.5">1.3.5</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.3.5">1.3.5</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark"><code>flexmark-*</code></a><br/>(<a href="https://github.com/vsch/flexmark-java/blob/master/VERSION.md#0640">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.64.0"><b>0.64.0</b></a><br/><span style="color:gray;font-size:80%;">(Feb&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations"><code>jackson-annotations</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.13.2"><b>2.13.2</b></a><br/><span style="color:gray;font-size:80%;">(Mar&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.2.3">2.2.3</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.2.3">2.2.3</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.12.1">2.12.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.12.1">2.12.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.12.1">2.12.1</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core"><code>jackson-core</code></a><br/>(<a href="https://github.com/FasterXML/jackson/wiki/Jackson-Releases">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core/2.13.2"><b>2.13.2</b></a><br/><span style="color:gray;font-size:80%;">(Mar&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core/2.9.8">2.9.8</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core/2.9.8">2.9.8</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core/2.12.1">2.12.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core/2.12.1">2.12.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core/2.12.1">2.12.1</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind"><code>jackson-databind</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind/2.13.2"><b>2.13.2</b></a><br/><span style="color:gray;font-size:80%;">(Mar&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.2.3">2.2.3</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.2.3">2.2.3</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.12.1">2.12.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.12.1">2.12.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.12.1">2.12.1</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml"><code>jackson-dataformat-yaml</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml/2.13.2"><b>2.13.2</b></a><br/><span style="color:gray;font-size:80%;">(Mar&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml/2.9.8">2.9.8</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml/2.9.8">2.9.8</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml/2.12.1">2.12.1</a></td></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml/2.12.1">2.12.1</a></td></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml/2.12.1">2.12.1</a></td></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader"><code>jline-reader</code></a><br/>(<a href="https://github.com/jline/jline3/blob/master/changelog.md">changelog</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader/3.21.0"><b>3.21.0</b></a><br/><span style="color:gray;font-size:80%;">(Oct&nbsp;s2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader/3.19.0">3.19.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader/3.19.0">3.19.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader/3.19.0">3.19.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader/3.19.0">3.19.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader/3.19.0">3.19.0</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna"><code>jna</code></a><br/>(<a href="https://github.com/java-native-access/jna/blob/master/CHANGES.md">changelog</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.10.0"><b>5.10.0</b></a><br/><span style="color:gray;font-size:80%;">(Nov&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup" rel="external"><code>jsoup</code></a><br/>(<a href="https://jsoup.org/news/" rel="external">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.14.3"><b>1.14.3</b></a><br/><span style="color:gray;font-size:80%;">(Sep&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.13.1">1.13.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.13.1">1.13.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.14.3">1.14.3</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.14.3">1.14.3</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.14.3">1.14.3</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp"><code>liqp</code></a><br/>(<a href="https://github.com/bkiers/Liqp/releases" rel="external">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.8.2"><b>0.8.2</b></a><br/><span style="color:gray;font-size:80%;">(Oct&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.6.7">0.6.7</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.6.7">0.6.7</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.8.2">0.8.2</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.8.2">0.8.2</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.8.2" rel="external">0.8.2</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java"><code>protobuf-java</code></a><br/>(<a href="https://github.com/protocolbuffers/protobuf/releases" rel="external">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java/3.19.4"><b>3.19.4</b></a><br/><span style="color:gray;font-size:80%;">(Jan&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java/3.7.0">3.7.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java/3.7.0">3.7.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java/3.7.0">3.7.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java/3.7.0">3.7.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java/3.7.0">3.7.0</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm"><code>scala-asm</code></a> <sup id="anchor_02"><a href="#footnote_02">2</a></sup></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.2.0-scala-1"><b>9.2.0</b></a><br/><span style="color:gray;font-size:80%;">(Jul 2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.1.0-scala-1">9.1.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.1.0-scala-1">9.1.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.1.0-scala-1">9.1.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.2.0-scala-1">9.2.0</a> <sup id="anchor_03"><a href="#footnote_03">3</a></sup></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.2.0-scala-1">9.2.0</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library"><code>scala-library</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.8"><b>2.13.8</b></a><br/><span style="color:gray;font-size:80%;">(Jan&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.6">2.13.6</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.6">2.13.6</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.8">2.13.8</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.8">2.13.8</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.8">2.13.8</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml" rel="external"><code>snakeyaml</code></a><br/>(<a href="https://bitbucket.org/snakeyaml/snakeyaml/wiki/Changes">changelog</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.30" rel="external"><b>1.30</b></a><br/><span style="color:gray;font-size:80%;">(Dec&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.23" rel="external">1.23</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.23" rel="external">1.23</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.27" rel="external">1.27</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.27" rel="external">1.27</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.27" rel="external">1.27</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4"><code>ST4</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.3.1"><b>4.3.1</b></a><br/><span style="color:gray;font-size:80%;">(Jun&nbsp;2020)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.0.7">4.0.7</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.0.7">4.0.7</a></td>
  <td style="padding:4px;color:red;"><b>removed</b></td>
  <td style="padding:4px;color:red;"><b>removed</b></td>
  <td style="padding:4px;color:red;"><b>removed</b></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface"><code>util-interface</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.6.2"><b>1.6.2</b></a><br/><span style="color:gray;font-size:80%;">(Jan&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.3.0">1.3.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.3.0">1.3.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.3.0">1.3.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.3.0">1.3.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.3.0">1.3.0</a></td>
</tr>
</table>


## <span id="scala30_releases">Dependencies in Scala 3.0 Releases</span>

As mentioned in the introduction the Scala 3.0 distributions depend on *many* external libraries.

<table style="font-size:80%;">
<tr>
  <th style="padding:4px;min-width:115px;">Java Archive</th>
  <th style="padding:4px;">Current<br/>Version</th>
  <th style="padding:4px;"><a href="https://github.com/lampepfl/dotty/releases/tag/3.0.0">3.0.0</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://github.com/lampepfl/dotty/releases/tag/3.0.1">3.0.1</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://github.com/lampepfl/dotty/releases/tag/3.0.2">3.0.2</a><br/><span style="color:gray;">final</span></th>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr4"><code>antlr-*</code></a><br/>(<a href="https://github.com/antlr/antlr4/releases">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr4/4.9.3"><b>4.9.3</b></a><br/><span style="color:gray;font-size:80%;">(Nov&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr/3.5.1">3.5.1</a><br/><span style="color:gray;font-size:80%;">(Sep&nbsp;2013)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr/3.5.1">3.5.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr/3.5.1">3.5.1</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink"><code>autolink-*</code></a><br/>(<a href="https://github.com/robinst/autolink-java/releases">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.10.0"><b>0.10.0</b></a><br/><span style="color:gray;font-size:80%;">(Jul 2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a><br/><span style="color:gray;font-size:80%;">(2016)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface"><code>compiler-interface</code></a><br/>(<a href="https://github.com/sbt/zinc/releases" rel="external">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.6.1"><b>1.6.1</b></a><br/><span style="color:gray;font-size:80%;">(Jan&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.3.5">1.3.5</a><br/><span style="color:gray;font-size:80%;">(2020)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.3.5">1.3.5</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.3.5">1.3.5</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark"><code>flexmark-*</code></a><br/>(<a href="https://github.com/vsch/flexmark-java/blob/master/VERSION.md#0640">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.64.0"><b>0.64.0</b></a><br/><span style="color:gray;font-size:80%;">(Feb&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a><br/><span style="color:gray;">(2019)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations"><code>jackson-annotations</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.13.2"><b>2.13.2</b></a><br/><span style="color:gray;font-size:80%;">(Mar&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.2.3">2.2.3</a><br/><span style="color:gray;font-size:80%;">(2013)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.2.3">2.2.3</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.2.3">2.2.3</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core"><code>jackson-core</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core/2.13.2"><b>2.13.2</b></a><br/><span style="color:gray;font-size:80%;">(Mar&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core/2.9.8">2.9.8</a><br/><span style="color:gray;">(2018)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core/2.9.8">2.9.8</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-core/2.9.8">2.9.8</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind"><code>jackson-databind</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind/2.13.2"><b>2.13.2</b></a><br/><span style="color:gray;font-size:80%;">(Mar&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind/2.2.3">2.2.3</a><br/><span style="color:gray;font-size:80%;">(Aug&nbsp;2013)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.2.3">2.2.3</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-annotations/2.2.3">2.2.3</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml"><code>jackson-dataformat-yaml</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml/2.13.2"><b>2.13.2</b></a><br/><span style="color:gray;font-size:80%;">(Mar&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml/2.9.8">2.9.8</a><br/><span style="color:gray;">(2018)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml/2.9.8">2.9.8</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.fasterxml.jackson.dataformat/jackson-dataformat-yaml/2.9.8">2.9.8</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader"><code>jline-reader</code></a><br/>(<a href="https://github.com/jline/jline3/blob/master/changelog.md">changelog</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader/3.21.0"><b>3.21.0</b></a><br/><span style="color:gray;font-size:80%;">(Oct&nbsp;s2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader/3.19.0">3.19.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader/3.19.0">3.19.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline-reader/3.19.0">3.19.0</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna"><code>jna</code></a><br/>(<a href="https://github.com/java-native-access/jna/blob/master/CHANGES.md">changelog</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.10.0"><b>5.10.0</b></a><br/><span style="color:gray;font-size:80%;">(Nov&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a><br/><span style="color:gray;font-size:80%;">(Mar&nbsp;2019)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvn&nbsp;repository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup" rel="external"><code>jsoup</code></a><br/>(<a href="https://jsoup.org/news/" rel="external">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.14.3" rel="external"><b>1.14.3</b></a><br/><span style="color:gray;font-size:80%;">(Sep&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.13.1" rel="external">1.13.1</a><br/><span style="color:gray;">(Mar&nbsp;2020)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.13.1" rel="external">1.13.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.13.1" rel="external">1.13.1</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp"><code>liqp</code></a><br/>(<a href="https://github.com/bkiers/Liqp/releases" rel="external">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.8.2"><b>0.8.2</b></a><br/><span style="color:gray;font-size:80%;">(Oct&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.6.7">0.6.7</a><br/><span style="color:gray;">(2016)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.6.7">0.6.7</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.6.7">0.6.7</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java"><code>protobuf-java</code></a><br/>(<a href="https://github.com/protocolbuffers/protobuf/releases" rel="external">relnotes</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java/3.19.4"><b>3.19.4</b></a><br/><span style="color:gray;font-size:80%;">(Jan&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java/3.7.0">3.7.0</a><br/><span style="color:gray;">(2019)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java/3.7.0">3.7.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.google.protobuf/protobuf-java/3.7.0">3.7.0</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm"><code>scala-asm</code></a> <sup id="anchor_02"><a href="#footnote_02">2</a></sup></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.2.0-scala-1"><b>9.2.0</b></a><br/><span style="color:gray;font-size:80%;">(Jul 2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.1.0-scala-1">9.1.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.1.0-scala-1">9.1.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.1.0-scala-1">9.1.0</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library" rel="external"><code>scala-library</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.8" rel="external"><b>2.13.8</b></a><br/><span style="color:gray;font-size:80%;">(Jan&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.5" rel="external">2.13.5</a><br/><span style="color:gray;font-size:80%;">(Feb&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.6" rel="external">2.13.6</a><br/><span style="color:gray;font-size:80%;">(May&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.6" rel="external">2.13.6</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml"><code>snakeyaml</code></a><br/>(<a href="https://bitbucket.org/snakeyaml/snakeyaml/wiki/Changes">changelog</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.30"><b>1.30</b></a><br/><span style="color:gray;font-size:80%;">(Dec&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.23">1.23</a><br/><span style="color:gray;font-size:80%;">(Aug&nbsp;2018)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.23">1.23</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.23">1.23</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4"><code>ST4</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.3.1"><b>4.3.1</b></a><br/><span style="color:gray;font-size:80%;">(Jun&nbsp;2020)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.0.7">4.0.7</a><br/><span style="color:gray;font-size:80%;">(Jan&nbsp;2013)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.0.7">4.0.7</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.0.7">4.0.7</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface"><code>util-interface</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.6.2"><b>1.6.2</b></a><br/><span style="color:gray;font-size:80%;">(Jan&nbsp;2022)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.3.0">1.3.0</a><br/><span style="color:gray;font-size:80%;">(Sep&nbsp;2019)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.3.0">1.3.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.3.0">1.3.0</a></td>
</tr>
</table>

## <span id="scala213_releases">Dependencies in Scala 2.13 Releases</span>

The following table presents the library dependencies of the Scala 2.13 distributions.

<table style="font-size:80%;">
<tr>
  <th style="padding:4px;min-width:115px;">Java Archive</th>
  <th style="padding:4px;">Current<br/>Version</th>
  <th style="padding:4px;"><a href="https://www.scala-lang.org/download/2.13.3.html">2.13.3</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://www.scala-lang.org/download/2.13.4.html">2.13.4</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://www.scala-lang.org/download/2.13.5.html">2.13.5</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://www.scala-lang.org/download/2.13.6.html">2.13.6</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://www.scala-lang.org/download/2.13.7.html">2.13.7</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://www.scala-lang.org/download/2.13.8.html">2.13.8</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://app.travis-ci.com/github/scala/scala/branches">2.13.9</a><br/><span style="color:red;">DEV</span></th>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline" rel="external"><code>jline</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline/3.21.0" rel="external"><b>3.21.0</b></a><br/><span style="color:gray;font-size:80%;">(Oct&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline/3.15.0" rel="external">3.15.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline/3.16.0" rel="external">3.16.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline/3.19.0" rel="external">3.19.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline/3.19.0" rel="external">3.19.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline/3.20.0" rel="external">3.20.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jline/jline/3.21.0" rel="external">3.21.0</a> <sup id="anchor_01"><a href="#footnote_01">1</a></sup></td>
  <td style="padding:4px;"><i>-</i></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna"><code>jna</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.10.0"><b>5.10.0</b></a><br/><span style="color:gray;font-size:80%;">(Nov&nbsp;2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a><br/><span style="color:gray;font-size:80%;">(Apr&nbsp;2019)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.3.1">5.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.8.0">5.8.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna/5.9.0">5.9.0</a> <sup id="anchor_01"><a href="#footnote_01">1</a></sup></td>
  <td style="padding:4px;">-</td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm"><code>scala-asm</code></a> <sup id="anchor_02"><a href="#footnote_02">2</a></sup></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.2.0-scala-1"><b>9.2.0</b></a><br/><span style="color:gray;font-size:80%;">(Jul 2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/7.3.1-scala-1">7.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/7.3.1-scala-1">7.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.1.0-scala-1">9.1.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.1.0-scala-1">9.1.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.2.0-scala-1">9.2.0</a> <sup id="anchor_03"><a href="#footnote_03">3</a></sup></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.2.0-scala-1">9.2.0</a></td>
  <td style="padding:4px;">-</td>
</tr>
</table>

## <span id="scala212_releases">Dependencies in Scala 2.12 Releases</span>

The following table presents the library dependencies of the Scala 2.12 distributions.

<table style="font-size:80%;">
<tr>
  <th style="padding:4px;min-width:115px;">Java Archive</th>
  <th style="padding:4px;">Current<br/>Version</th>
  <th style="padding:4px;"><a href="https://www.scala-lang.org/download/2.12.12.html">2.12.12</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://www.scala-lang.org/download/2.12.13.html">2.12.13</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://www.scala-lang.org/download/2.12.14.html">2.12.14</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://github.com/scala/scala/releases/tag/v2.12.15">2.12.15</a><br/><span style="color:gray;">final</span></th>
  <th style="padding:4px;"><a href="https://app.travis-ci.com/github/scala/scala/branches">2.12.16</a><br/><span style="color:red;">DEV</span></th>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/jline/jline"><code>jline</code></a><br/><i>(version 2)</i></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/jline/jline/2.14.6"><b>2.14.6</b></a><br/><span style="color:gray;font-size:80%;">(Nov&nbsp;2007)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/jline/jline/2.14.6">2.14.6</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/jline/jline/2.14.6">2.14.6</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/jline/jline/2.14.6">2.14.6</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/jline/jline/2.14.6">2.14.6</a></td>
  <td style="padding:4px;">-</td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm" rel="external"><code>scala-asm</code></a> <sup id="anchor_02"><a href="#footnote_02">2</a></sup></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.2.0-scala-1" rel="external"><b>9.2.0</b></a><br/><span style="color:gray;font-size:80%;">(Jul 2021)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/7.3.1-scala-1" rel="external">7.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/7.3.1-scala-1" rel="external">7.3.1</a</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.1.0-scala-1" rel="external">9.1.0</a</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.2.0-scala-1" rel="external">9.2.0</a></td>
  <td style="padding:4px;">-</td>
</tr>
</table>

## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> **`jline 3.21.0` and `JNA 5.9.0` *Library Updates*** [↩](#anchor_01)

<dl><dd>
Update 3.21.0 of the <a href="https://mvnrepository.com/artifact/org.jline/jline" rel="external"><code>JLine</code></a> library and update 5.9.0 of the <a href="https://mvnrepository.com/artifact/net.java.dev.jna/jna" rel="external"><code>JNA</code></a> library make REPL work again on Mac M1  (see <a href="https://github.com/scala/scala/pull/9807" rel="external">pull 9807</a>).
</dd></dl>

<span id="footnote_02">[2]</span> **`scala-asm` *Library*** [↩](#anchor_02)

<dl><dd>
Scala 3 and Scala 2 software distributions are packaged differently regarding their dependency on the <a href="https://asm.ow2.io" rel="external">ASM</a> library (actually a fork of it):
</dd>
<dd>
<ul>
<li>In Scala 2 <a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm" rel="external"><code>scala-asm</code></a> is hidden into <a href="https://mvnrepository.com/artifact/org.scala-lang/scala-compiler" rel="external"><code>scala-compiler.jar</code></a></li>
<li>In Scala 3 <a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm" rel="external"><code>scala-asm</code></a> is a separate archive file.
</ul>
</dd>
<dd>
We wrote the batch file <a href="bin/getasm.bat"><b><code>getasm.bat</code></b></a> (~200 lines) to extract the <a href="https://asm.ow2.io/">ASM</a> version from the Scala 2 and Scala 3 distributions (using file <b><code>scala-asm.properties</code></b>). Here is a sample output :
</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="bin/getasm.bat">getasm</a> run</b>
Found ASM version "7.0.0-scala-1" in Scala 2 installation is "C:\opt\scala-2.12.10"
Found ASM version "7.3.1-scala-1" in Scala 2 installation is "C:\opt\scala-2.12.11"
Found ASM version "9.1.0-scala-1" in Scala 2 installation is "C:\opt\scala-2.12.14"
Found ASM version "9.2.0-scala-1" in Scala 2 installation is "C:\opt\scala-2.12.15"
Found ASM version "7.3.1-scala-1" in Scala 2 installation is "C:\opt\scala-2.13.4"
Found ASM version "9.1.0-scala-1" in Scala 2 installation is "C:\opt\scala-2.13.5"
Found ASM version "9.1.0-scala-1" in Scala 2 installation is "C:\opt\scala-2.13.6"
Found ASM version "9.2.0-scala-1" in Scala 2 installation is "C:\opt\scala-2.13.7"
Found ASM version "9.2.0-scala-1" in Scala 2 installation is "C:\opt\scala-2.13.8"
Found ASM version "9.1.0-scala-1" in Scala 3 installation is "C:\opt\scala3-3.0.0"
Found ASM version "9.1.0-scala-1" in Scala 3 installation is "C:\opt\scala3-3.0.2"
Found ASM version "9.1.0-scala-1" in Scala 3 installation is "C:\opt\scala3-3.1.0"
Found ASM version "9.1.0-scala-1" in Scala 3 installation is "C:\opt\scala3-3.1.1"
Found ASM version "9.1.0-scala-1" in Scala 3 installation is "C:\opt\scala3-3.1.2-RC2"
</pre>
</dd></dl>

<span id="footnote_03">[3]</span> **`scala-asm 9.2.0` *Library Update*** [↩](#anchor_03)

<!-- https://javaalmanac.io/ -->

<dl><dd>
Update 9.2.0 of the <a href="https://gitlab.ow2.org/asm/asm/-/commit/1412c76" rel="external"><code>scala-asm</code></a> library adds support of Java version 18 (version 62).
</dd></dl>

<!--
<span name="footnote_03">[3]</span> ***Dependencies in Scala3 Development Versions*** [↩](#anchor_03)

<table style="margin:0 0 0 20px;font-size:80%;">
<tr>
  <th style="min-width:115px;">Java Archive</th>
  <th>Current Version</th>
  <th><a href="https://github.com/lampepfl/dotty/releases/tag/0.24.0">0.24.0</a><br/><span style="color:gray;">final</span></th>
  <th><a href="https://github.com/lampepfl/dotty/releases/tag/0.25.0">0.25.0</a><br/><span style="color:gray;">final</span></th>
  <th><a href="https://github.com/lampepfl/dotty/releases/tag/0.26.0">0.26.0</a><br/><span style="color:gray;">final</span></th>
  <th><a href="https://github.com/lampepfl/dotty/releases/tag/0.27.0-RC1">0.27.0</a><br/><span style="color:red;">RC1</span></th>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr"><code>antlr-*</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr4/4.9.2"><b>4.9.2</b></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr/3.5.1">3.5.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr/3.5.1">3.5.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr/3.5.1">3.5.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/antlr/3.5.1">3.5.1</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink"><code>autolink</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.10.0"><b>0.10.0</b></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.nibor.autolink/autolink/0.6.0">0.6.0</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface"><code>compiler-interface</code></a></td>
  <td style="padding:4px;"><a href=""><b>1.6.0</b></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.2.5">1.2.5</a><br/><span style="color:gray;">(2018)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.2.5">1.2.5</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.2.5">1.2.5</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/compiler-interface/1.2.5">1.2.5</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark"><code>flexmark-*</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.62.2"><b>0.62.2</b></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a><br/><span>(2019)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/com.vladsch.flexmark/flexmark/0.42.12">0.42.12</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup"><code>jsoup</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.14.3"><b>1.14.3</b></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.7.2">1.7.2</a><br/><span style="color:gray;">(2013)</span></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.7.2">1.7.2</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.7.2">1.7.2</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.jsoup/jsoup/1.7.2">1.7.2</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp"><code>liqp</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.8.0"><b>0.8.0</b></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.6.7">0.6.7</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.6.7">0.6.7</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.6.7">0.6.7</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/nl.big-o/liqp/0.6.7">0.6.7</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm"><code>scala-asm</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/9.2.0-scala-1"><b>9.2.0</b></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/7.3.1-scala-1">7.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/7.3.1-scala-1">7.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/7.3.1-scala-1">7.3.1</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang.modules/scala-asm/7.3.1-scala-1">7.3.1</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library"><code>scala-library</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.6"><b>2.13.6</b></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.2">2.13.2</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.2">2.13.2</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.3">2.13.3</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-lang/scala-library/2.13.3">2.13.3</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml"><code>snakeyaml</code></a><br/>(<a href="https://bitbucket.org/snakeyaml/snakeyaml/wiki/Changes">changelog</a>)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.29"><b>1.29</b></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.23">1.23</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.23">1.23</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.23">1.23</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.yaml/snakeyaml/1.23">1.23</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4"><code>ST4</code></a> (ANTLR)</td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.3.1"><b>4.3.1</b></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.0.7">4.0.7</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.0.7">4.0.7</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.0.7">4.0.7</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.antlr/ST4/4.0.7">4.0.7</a></td>
</tr>
<tr>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface"><code>util-interface</code></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.6.0-M1"><b>1.6.0</b></a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.2.2">1.2.2</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.2.2">1.2.2</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.2.2">1.2.2</a></td>
  <td style="padding:4px;"><a href="https://mvnrepository.com/artifact/org.scala-sbt/util-interface/1.2.2">1.2.2</a></td>
</tr>
</table>
-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2022* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->


