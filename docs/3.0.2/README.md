# <span id="top">Scala Manual Pages</span> <span style="size:30%;"><a href="../../README.md">⬆</a></span>

We generate both versions of the manual pages with the [Pandoc][pandoc] tool <sup id="anchor_01">[1](#footnote_01)</sup>.

## <span id="previews">HTML Previews</span>

Scala 3 commands :
<pre>
<a href="https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scala.1.html"><b>scala</b>.1.html</a>, <a href="https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scalac.1.html"><b>scalac</b>.1.html</a>, <a href="
https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scaladoc.1.html"><b>scaladoc</b>.1.html</a>
</pre>

Third-Part Scala commands :
<pre>
<a href="
https://htmlpreview.github.io/?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/amm.1.html"><b>amm</b>.1.html</a>, <a href="
https://htmlpreview.github.io/?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/cs.1.html"><b>cs</b>.1.html</a>, <a href="
https://htmlpreview.github.io/?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/gradle.1.html"><b>gradle</b>.1.html</a>,<br/><a href="
https://htmlpreview.github.io/?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/mill.1.html"><b>mill</b>.1.html</a>, <a href="
https://htmlpreview.github.io/?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/sbt.1.html"><b>sbt</b>.1.html</a>, <a href="
https://htmlpreview.github.io/?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scala-cli.1.html"><b>scala-cli</b>.1.html</a><br/><a href="
https://htmlpreview.github.io/?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scalafix.1.html"><b>scalafix</b>.1.html</a>, <a href="
https://htmlpreview.github.io/?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scalafmt.1.html"><b>scalafmt</b>.1.html</a>
</pre>

> **:mag_right:** We add the prefix `https://htmlpreview.github.io/?<html_page_url>` to the URL of the HTML pages from our GitHub repository in order the view them.

## <span id="downloads">Downloads</span>

We've grouped the generated manual pages in 4 Zip archives :

| &nbsp;     | Scala 3 Commands&nbsp;<sup id="anchor_02">[2](#footnote_02)</sup> | Third-Party&nbsp;Commands |
|:-----------|:-----------------|:--------------------------|
| HTML&nbsp;pages | [`scala3-html-3.0.2.zip`](scala3-html-3.0.2.zip) | [`scala3-thirdparty-html-3.0.2.zip`](scala3-thirdparty-html-3.0.2.zip)  |
| GZ&nbsp;pages   | [`scala3-man-3.0.2.zip`](scala3-man-3.0.2.zip)| [`scala3-thirdparty-man-3.0.2.zip`](scala3-thirdparty-man-3.0.2.zip) |

## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> ***Pandoc*** [↩](#anchor_01)

<dl><dd>
We generate the manual pages in 6 steps :
<ol>
<li>We replace text placeholders (e.g. <code>@@DATE@@</code>) in the source file with <a href="https://www.gnu.org/software/sed/manual/sed.html#Command_002dLine-Options"><code>sed</code></a>.</li>
<li>We generate the manual page with <a href="https://pandoc.org/MANUAL.html"><code>pandoc</code></a>.</li>
<li>We compress the manual page with <a href="https://www.gnu.org/software/gzip/manual/gzip.html#Sample"><code>gzip</code></a>.</li>
<li>We generate the HTML manual page with <a href="https://pandoc.org/MANUAL.html"><code>pandoc</code></a>.</li>
<li>We update headerand add footer in the generated HTML file with <a href="https://www.gnu.org/software/sed/manual/sed.html#Command_002dLine-Options"><code>sed</code></a>.</li>
<li>We create two Zip archives with manual pages with <a href="https://www.7-zip.org/"><code>7-Zip</code></a></li>
</ol>
</dd>
<dd>
<table style="text-align:center;font-size:80%;">
<tr>
<td style="width:360px;padding:0;">
Source file<br/><code>src/scala.1.md</code>
</td>
</tr>
</table>
<table style="margin-top:-16px;text-align:center;font-size:80%;">
<tr>
<td style="width:180px;vertical-align:top;padding:0;">
<b>&#8681;</b> (1)<br/>
Patched source file<br/><code>target/src_gen/scala.1.md</code><br/>
<b>&#8681;</b> (2)<br/>
Manpage file<br/><code>target/man/man1/scala.1</code><br/>
<b>&#8681;</b> (3)<br/>
Gzipped file<br/><code>target/man/man1/scala.1.gz</code>
</td>
<td style="width:180px;vertical-align:top;padding:0;">
<b>&#8681;</b> (4)<br/>
HTML file<br/><code>target/man/man1/scala.1.html</code><br/>
<b>&#8681;</b> (5)<br/>
Patched HTML file<br/><code>target/man/man1/scala.1.html</code>
</td>
</tr>
<tr><td style="width:180px;text-align:center;padding:0;">
<b>&#8681;</b> (6)<br/>
Zip archive<br/><code>target/scala3-html-3.0.2.zip</code>
</td>
<td style="width:180px;text-align:center;padding:0;">
<b>&#8681;</b> (6)<br/>
Zip archive<br/><code>target/scala3-html-3.0.2.zip</code>
</td></tr>
</table>
</dd></dl>

<span id="footnote_02">[2]</span> ***Zip Archives*** [↩](#anchor_02)

<dl><dd>
For instance, the Zip archives for Scala 3 commands contain the following files :

</dd>
<dd>
<pre style="font-size:80%;">
<b>&gt; <a href="https://linux.die.net/man/1/unzip" rel="external">unzip</a> -l scala3-html-3.0.2.zip | <a href="https://linux.die.net/man/1/grep" rel="external">grep</a> html</b>
Archive:  scala3-html-3.0.2.zip
        0  2022-03-31 14:43   doc/html/
    16971  2022-03-31 14:43   doc/html/scala.1.html
    38791  2022-03-30 14:53   doc/html/scalac.1.html
    14171  2022-03-31 14:43   doc/html/scaladoc.1.html
&nbsp;
<b>&gt; <a href="https://linux.die.net/man/1/unzip" rel="external">unzip</a> -l scala3-man-3.0.2.zip | <a href="https://linux.die.net/man/1/grep" rel="external">grep</a> man</b>
Archive:  scala3-man-3.0.2.zip
        0  2022-03-30 12:00   man/
        0  2022-03-31 14:43   man/man1/
     3534  2022-03-31 14:43   man/man1/scala.1.gz
     8600  2022-03-30 14:53   man/man1/scalac.1.gz
     3157  2022-03-31 14:43   man/man1/scaladoc.1.gz
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/April 2022* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[pandoc]: https://pandoc.org/installing.html