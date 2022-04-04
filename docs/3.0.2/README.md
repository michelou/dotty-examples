# <span id="top">Scala 3 Manual Pages</span> <span style="size:30%;"><a href="../../README.md">⬆</a></span>

We use the [Pandoc][pandoc] tool <sup id="anchor_01">[1](#footnote_01)</sup> to generate the [HTML] and the [troff] versions of the manual pages.

> **:mag_right:** 4 examples of online manual pages :
> - [Ubuntu](https://manpages.ubuntu.com/) hosted [manual pages](http://manpages.ubuntu.com/manpages/jammy/) (includes [`scala.1`](https://manpages.ubuntu.com/manpages/jammy/en/man1/scala.1.html), Scala 2.11).
> - [FreeBSD](https://www.freebsd.org/) hosted [manual pages](https://www.freebsd.org/cgi/man.cgi) (includes [`scala.1`](https://www.freebsd.org/cgi/man.cgi?query=scala&format=html), Scala 0.5).
> - [Hurrican Electric](https://www.he.net/) hosted [manual pages](http://man.he.net/).
> - [man7.org](https://man7.org/) hosted [manual pages](https://man7.org/linux/man-pages/index.html).

## <span id="previews">HTML Previews</span>

The Scala 3 commands are :
<pre>
<a href="https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scala.1.html" rel="external"><b>scala</b>.1.html</a>, <a href="https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scalac.1.html" rel="external"><b>scalac</b>.1.html</a>, <a href="
https://tinyurl.com/2p8zevyt?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scaladoc.1.html"><b>scaladoc</b>.1.html</a>
</pre>

test: <a href="
https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/amm.1.html" rel="external"><b>amm</b>.1.html</a>

The third-party Scala commands are :
<pre>
<a href="
https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/amm.1.html" rel="external"><b>amm</b>.1.html</a>, <a href="
https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/cs.1.html" rel="external"><b>cs</b>.1.html</a>, <a href="
https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/gradle.1.html" rel="external"><b>gradle</b>.1.html</a>,<br/><a href="
https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/mill.1.html" rel="external"><b>mill</b>.1.html</a>, <a href="
https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/sbt.1.html" rel="external"><b>sbt</b>.1.html</a>, <a href="
https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scala-cli.1.html" rel="external"><b>scala-cli</b>.1.html</a><br/><a href="
https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scalafix.1.html" rel="external"><b>scalafix</b>.1.html</a>, <a href="
https://tinyurl.com/2p9cn8ns?https://github.com/michelou/dotty-examples/blob/master/docs/3.0.2/html/scalafmt.1.html" rel="external"><b>scalafmt</b>.1.html</a>
</pre>

> **:mag_right:** HTML pages hosted in a GitHub repository can be viewed by adding the prefix [`https://htmlpreview.github.io/?`][github_htmlpreview] to their URL.

## <span id="downloads">Downloads</span>

We've grouped the generated manual pages in 4 Zip archives :

| &nbsp;     | Scala 3 Commands&nbsp;<sup id="anchor_02">[2](#footnote_02)</sup> | Third-party&nbsp;Commands |
|:-----------|:-----------------|:--------------------------|
| **HTML&nbsp;files** | [`scala3-html-3.0.2.zip`](scala3-html-3.0.2.zip) | [`scala3-thirdparty-html-3.0.2.zip`](scala3-thirdparty-html-3.0.2.zip)  |
| **GZ&nbsp;files**   | [`scala3-man-3.0.2.zip`](scala3-man-3.0.2.zip)| [`scala3-thirdparty-man-3.0.2.zip`](scala3-thirdparty-man-3.0.2.zip) |

## <span id="footnotes">Footnotes</span>

<span id="footnote_01">[1]</span> ***Pandoc Generation*** [↩](#anchor_01)

<dl><dd>
We generate the manual pages in 6 steps :
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
troff file<br/><code>target/man/man1/scala.1</code><br/>
<b>&#8681;</b> (3)<br/>
GZ file<br/><code>target/man/man1/scala.1.gz</code>
</td>
<td style="width:180px;vertical-align:top;padding:0;">
<b>&#8681;</b> (4)<br/>
HTML file<br/><code>target/man/man1/scala.1.html</code><br/>
<b>&#8681;</b> (5)<br/>
Patched HTML file<br/><code>target/man/man1/scala.1.html</code><br/>
&nbsp;<br/>
&nbsp;<br/>
</td>
</tr>
<tr><td style="width:180px;text-align:center;padding:0;">
<b>&#8681;</b> (6)<br/>
Zip archive<br/><code>target/scala3-man-3.0.2.zip</code>
</td>
<td style="width:180px;text-align:center;padding:0;">
<b>&#8681;</b> (6)<br/>
Zip archive<br/><code>target/scala3-html-3.0.2.zip</code>
</td></tr>
</table>
</dd>
<dd>
<ol>
<li>We replace text placeholders (e.g. <code>@@DATE@@</code>) in the source file with <a href="https://www.gnu.org/software/sed/manual/sed.html#Command_002dLine-Options"><code>sed</code></a>.</li>
<li>We generate the <a href="https://en.wikipedia.org/wiki/Troff"> troff</a> manual page with <a href="https://pandoc.org/MANUAL.html"><code>pandoc -s -t man</code></a>.</li>
<li>We compress the manual page with <a href="https://www.gnu.org/software/gzip/manual/gzip.html#Sample"><code>gzip</code></a>.</li>
<li>We generate the <a href="https://html.spec.whatwg.org/multipage/">HTML</a> manual page with <a href="https://pandoc.org/MANUAL.html"><code>pandoc-s -t html</code></a>.</li>
<li>We modify the header and add a footer to the generated HTML file with <a href="https://www.gnu.org/software/sed/manual/sed.html#Command_002dLine-Options"><code>sed</code></a>.</li>
<li>We create a Zip archive for each set of manual pages with <a href="https://www.7-zip.org/"><code>7-Zip</code></a>.</li>
</ol>
</dd></dl>

<span id="footnote_02">[2]</span> ***Zip Archives*** [↩](#anchor_02)

<dl><dd>
For instance, the two Zip archives for the <a href="https://dotty.epfl.ch/" rel="external">Scala 3</a> commands contain the following files :

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

[github_htmlpreview]: https://htmlpreview.github.io/
[html]: https://html.spec.whatwg.org/multipage/
[pandoc]: https://pandoc.org/installing.html
[scala3_home]: https://dotty.epfl.ch/
[troff]: https://en.wikipedia.org/wiki/Troff
