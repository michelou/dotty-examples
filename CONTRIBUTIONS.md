# <span id="top">Contributing to the Dotty project</span> <span style="size:25%;"><a href="README.md">↩</a></span>

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:80px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:80px;" src="docs/dotty.png" alt="Dotty logo" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This document presents issues and pull requests we have sofar submitted to the <a href="https://github.com/lampepfl/dotty/" rel="external">Dotty</a> project.<br/>&nbsp;
  </td>
  </tr>
</table>

## <span id="issues">Reported Issues</span>

We have come across several issues <sup id="anchor_01"><a href="#footnote_01">[1]</a></sup> while executing [Scala 3][scala3] commands on Windows:

| [ &nbsp;&nbsp;&nbsp;&nbsp;Issues&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ](https://github.com/lampepfl/dotty/issues?q=is%3Aissue+author%3Amichelou) | &nbsp;&nbsp;Issue status&nbsp;&nbsp;&nbsp; | Context |
| :-------------------------: | :--------: | :--------- |
| [#11454][dotty_issue_11454] | [fixed][dotty_pull_11476] <span style="font-size:80%;">(Feb 2021)</span> | Command tools |
| [#11453][dotty_issue_11453] | [fixed][dotty_pull_11476] <span style="font-size:80%;">(Feb 2021)</span> | Command tools |
| [#11452][dotty_issue_11452] | [fixed][dotty_pull_11476] <span style="font-size:80%;">(Feb 2021)</span> | Command tools |
| [#11014][dotty_issue_11014] | *open* | Markdown files |
| [#8358][dotty_issue_8358] | *open* | Resource leak |
| [#8355][dotty_issue_8355] | [fixed][dotty_pull_8356] <span style="font-size:80%;">(Feb 2020)</span> | Test suite |
| [#8218][dotty_issue_8218] | [fixed][dotty_pull_8224] <span style="font-size:80%;">(Feb 2020)</span> | TASTy inspector |
| [#8124][dotty_issue_8124] | [fixed][dotty_pull_8279] | Compiler settings |
| [#7720][dotty_issue_7720] | [fixed][dotty_pull_7691] | Staging |
| [#7148][dotty_issue_7146] | [fixed](https://github.com/dotty-staging/dotty/commit/2c529c6) | Shell scripts |
| [#6868][dotty_issue_6868] | [fixed](https://github.com/lampepfl/dotty/commit/0ea949a) | Class file parser |
| [#6367][dotty_issue_6367] | *open* | Dotty REPL |
| [#4356][dotty_issue_4356] | [won't fix](https://github.com/lampepfl/dotty/issues/4356#event-2098905156) | Windows batch command |
| [#4272][dotty_issue_4272] | [fixed](https://github.com/lampepfl/dotty/commit/9723748) | Type constraints|

## <span id="pull_requests">Pull Requests</span>

| [Pull request](https://github.com/lampepfl/dotty/pulls?q=is%3Apr+author%3Amichelou) | Request status | Context |
| :------------------------: | :--------: | :--------- |
| [#11728][dotty_pull_11728] | *pending* | Reference documentation |
| [#11480][dotty_pull_11480] | [merged](https://github.com/lampepfl/dotty/commit/5eb3258) <span style="font-size:80%;">(Feb 2021)</span> | Reference documentation |
| [#11257][dotty_pull_11257] | *WIP*  | Reference documentation |
| [#11235][dotty_pull_11235] | [merged](https://github.com/lampepfl/dotty/commit/8d3275c) <span style="font-size:80%;">(Jan 2021)</span> | Reference documentation |
| [#11158][dotty_pull_11158] | [merged](https://github.com/lampepfl/dotty/commit/bbfff61) <span style="font-size:80%;">(Jan 2021)</span> | Reference documentation |
| [#11062][dotty_pull_11062] | [merged](https://github.com/lampepfl/dotty/commit/0f1d350) <span style="font-size:80%;">(Jan 2021)</span> | Reference documentation |
| [#11016][dotty_pull_11016] | [merged](https://github.com/lampepfl/dotty/commit/437d02a) <span style="font-size:80%;">(Jan 2021)</span> | Reference documentation |
| [#10953][dotty_pull_10953] | [merged](https://github.com/lampepfl/dotty/commit/141bf9e) <span style="font-size:80%;">(Dec 2020)</span> | Reference documentation |
| [#10875][dotty_pull_10875] | [merged](https://github.com/lampepfl/dotty/commit/626d24a) <span style="font-size:80%;">(Dec 2020)</span> | Reference documentation |
| [#10860][dotty_pull_10860] | [merged](https://github.com/lampepfl/dotty/commit/0e4fe3c) <span style="font-size:80%;">(Dec 2020)</span> | Reference documentation |
| [#10826][dotty_pull_10826] | [merged](https://github.com/lampepfl/dotty/commit/bfb0b81) <span style="font-size:80%;">(Dec 2020)</span> | Reference documentation |
| [#10767][dotty_pull_10767] | [merged](https://github.com/lampepfl/dotty/commit/3a7a6ae) <span style="font-size:80%;">(Dec 2020)</span> | Reference documentation |
| [#10448][dotty_pull_10448] | [merged](https://github.com/lampepfl/dotty/commit/51db1b5) <span style="font-size:80%;">(Nov 2020)</span> | Test suite |
| [#10304][dotty_pull_10304] | [merged](https://github.com/lampepfl/dotty/commit/9531534) <span style="font-size:80%;">(Mar 2021)</span> | Compiler options |
| [#8356][dotty_pull_8356] | [merged](https://github.com/lampepfl/dotty/commit/f51bf1b701a17851224472849c131ce6de38e2a7) <span style="font-size:80%;">(Feb 2020)</span> | Test suite |
| [#8330][dotty_pull_8330] | [merged](https://github.com/lampepfl/dotty/commit/5018a1285cf3d8c0f3a17f98f015589154b0fbbd) <span style="font-size:80%;">(Feb 2020)</span> | Test suite |
| [#8279][dotty_pull_8279] | [merged](https://github.com/lampepfl/dotty/commit/a5f1dae68202ba67ef99c39f243970ebd3530a65) <span style="font-size:80%;">(Feb.2020)</span> | Compiler options |
| [#6653][dotty_pull_6653] | [merged](https://github.com/lampepfl/dotty/commit/fe02bf4fdc14f648b5f42731e39448995963256c) <span style="font-size:80%;">(Jun 2019)</span> | Batch commands |
| [#5814](https://github.com/lampepfl/dotty/pull/5814) | [merged](https://github.com/lampepfl/dotty/commit/923fb06dc625e054e8b1833d4b7db49d369d91ad) <span style="font-size:80%;">(Jan 2019)</span> | **`build compile`** |
| [#5659](https://github.com/lampepfl/dotty/pull/5659) | [merged](https://github.com/lampepfl/dotty/commit/7b9ffbb56b2bd33efead1c0f38a71c057c31463e) <span style="font-size:80%;">(Dec 2018)</span> | **`build bootstrap`** |
| [#5587](https://github.com/lampepfl/dotty/pull/5587) | [merged](https://github.com/lampepfl/dotty/commit/172d6a0a1a3a4cbdb0a3ac4741b3f561d1221c40) <span style="font-size:80%;">(Dec 2018)</span> | **`build bootstrap`** |
| [#5561](https://github.com/lampepfl/dotty/pull/5561) | [merged](https://github.com/lampepfl/dotty/commit/24a2798f51e1cc01d476b9c00ac0e4b925acc8e5) <span style="font-size:80%;">(Dec 2018)</span> | **`build bootstrap`** |
| [#5487](https://github.com/lampepfl/dotty/pull/5487) | [merged](https://github.com/lampepfl/dotty/commit/052c3b1) <span style="font-size:80%;">(Nov 2018)</span> | **`build bootstrap`** |
| [#5457](https://github.com/lampepfl/dotty/pull/5457) | [merged](https://github.com/lampepfl/dotty/commit/eb175cb) <span style="font-size:80%;">(Nov 2018)</span> | **`build compile`** |
| [#5452](https://github.com/lampepfl/dotty/pull/5452) | [merged](https://github.com/lampepfl/dotty/commit/7e093b15ff2a927212c7f40aa36b71d0a28f81b5) <span style="font-size:80%;">(Nov 2018)</span> | Code review |
| [#5444](https://github.com/lampepfl/dotty/pull/5444) | [closed](https://github.com/lampepfl/dotty/pull/5444#issuecomment-567178490) | Batch commands |
| [#5430](https://github.com/lampepfl/dotty/pull/5430) | [merged](https://github.com/lampepfl/dotty/commit/81b30383800495c64f2c8cfd0979e69e504104bc) <span style="font-size:80%;">(Nov 2018)</span> | **`build documentation`** |

> **&#9755;** Related pull requests from other contributors include:<br/>
> <ul><li><a href="https://github.com/lampepfl/dotty/pull/5560">#5560</a> Fix Windows path (<a href="https://github.com/lampepfl/dotty/commit/67c86783ff48723ae96fedeb51c50db62f375042">merged</a>).</li>
> <li><a href="https://github.com/lampepfl/dotty/pull/5531">#5531</a> Test AppVeyor integration (<a href="https://github.com/lampepfl/dotty/pull/5531#issuecomment-446505630">closed</a>).</li></ul>

Below we summarize changes we made to the [source code](https://github.com/lampepfl/dotty/) of the [Scala 3][scala3] project:

- Unspecified character encoding in some file operations<br/>*Example*: [**`Source.fromFile(f)`**](https://www.scala-lang.org/api/2.12.7/scala/io/Source$.html) **&rarr;** **`Source.fromFile(f, "UTF-8")`**.
- Platform-specific new lines<br/>*Example*: **`"\n"`** **&rarr;** [**`System.lineSeparator`**](https://docs.oracle.com/javase/8/docs/api/java/lang/System.html#lineSeparator).
- Platform-specific path separators<br/>*Example*: **`":"`** **&rarr;** [**`java.io.File.pathSeparator`**](https://docs.oracle.com/javase/8/docs/api/java/io/File.html#pathSeparator).
- Illegal characters in file names<br/>*Example*: **`new PlainFile(Path("<quote>"))`** **&rarr;** **`new VirtualFile("<quote>")`**
- Transformation of URL addresses to file system paths<br/>*Example*: [**`url.getFile`**](https://docs.oracle.com/javase/8/docs/api/java/net/URL.html#getFile) **&rarr;** **`Paths.get(url.toURI).toString`**.
- Unspecified character encoding when piping stdout<br/>*Example*: **`new InputStreamReader(process.getInputStream)`** **&rarr;** **`new InputStreamReader(process.getInputStream, "UTF-8")`**<br/>where **`process`** has type [**`ProcessBuilder`**](https://docs.oracle.com/javase/8/docs/api/java/lang/ProcessBuilder.html).

## <span id="footnotes">Footnotes</span>

<span name="footnote_01">[1]</span> ***Git configuration*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
We report here one issue we encountered when working with the <a href="https://git-scm.com/docs/git-config"><b><code>git</code></b></a> command on Windows, namely the error message <code>"Filename too long"</code>:
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; <a href="https://git-scm.com/docs/git">git</a> status</b>
mainExamples/src/main/scala/examples/main/active/writing/toConsoleWriting/info/reading/argumentAndResultMultiplier/FactorialOfArgumentMultipliedByResultMultiplierMain.scala: Filename too long
   On branch batch-files
   Your branch is ahead of 'origin/batch-files' by 1106 commits.
      (use "git push" to publish your local commits)
</pre>
<p style="margin:0 0 1em 20px;">
We fixed our local <a href="https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration" rel="external">Git settings</a> as follows:
</p>
<pre style="margin:0 0 1em 20px;font-size:80%;">
<b>&gt; <a href="https://git-scm.com/docs/git">git</a> config --system core.longpaths true</b>
</pre>
</p>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/March 2021* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[scala3]: https://dotty.epfl.ch/
[dotty_issue_4272]: https://github.com/lampepfl/dotty/issues/4272
[dotty_issue_4356]: https://github.com/lampepfl/dotty/issues/4356
[dotty_issue_6367]: https://github.com/lampepfl/dotty/issues/6367
[dotty_issue_6868]: https://github.com/lampepfl/dotty/issues/6868
[dotty_issue_7146]: https://github.com/lampepfl/dotty/issues/7146
[dotty_issue_7720]: https://github.com/lampepfl/dotty/issues/7720
[dotty_issue_8124]: https://github.com/lampepfl/dotty/issues/8124
[dotty_issue_8218]: https://github.com/lampepfl/dotty/issues/8218
[dotty_issue_8355]: https://github.com/lampepfl/dotty/issues/8355
[dotty_issue_8358]: https://github.com/lampepfl/dotty/issues/8358
[dotty_issue_11014]: https://github.com/lampepfl/dotty/issues/11014
[dotty_issue_11452]: https://github.com/lampepfl/dotty/issues/11452 "Command line tools : option \"-version\""
[dotty_issue_11453]: https://github.com/lampepfl/dotty/issues/11453
[dotty_issue_11454]: https://github.com/lampepfl/dotty/issues/11454 "scaladoc tool : argument files (@-files)"
[dotty_pull_6653]: https://github.com/lampepfl/dotty/pull/6653
[dotty_pull_7691]: https://github.com/lampepfl/dotty/pull/7691
[dotty_pull_8224]: https://github.com/lampepfl/dotty/pull/8224
[dotty_pull_8279]: https://github.com/lampepfl/dotty/pull/8279
[dotty_pull_8330]: https://github.com/lampepfl/dotty/pull/8330
[dotty_pull_8356]: https://github.com/lampepfl/dotty/pull/8356
[dotty_pull_10304]: https://github.com/lampepfl/dotty/pull/10304
[dotty_pull_10448]: https://github.com/lampepfl/dotty/pull/10448
[dotty_pull_10767]: https://github.com/lampepfl/dotty/pull/10767
[dotty_pull_10826]: https://github.com/lampepfl/dotty/pull/10826
[dotty_pull_10860]: https://github.com/lampepfl/dotty/pull/10860
[dotty_pull_10875]: https://github.com/lampepfl/dotty/pull/10875
[dotty_pull_10953]: https://github.com/lampepfl/dotty/pull/10953
[dotty_pull_11016]: https://github.com/lampepfl/dotty/pull/11016
[dotty_pull_11062]: https://github.com/lampepfl/dotty/pull/11062
[dotty_pull_11158]: https://github.com/lampepfl/dotty/pull/11158
[dotty_pull_11235]: https://github.com/lampepfl/dotty/pull/11235
[dotty_pull_11257]: https://github.com/lampepfl/dotty/pull/11257
[dotty_pull_11476]: https://github.com/lampepfl/dotty/pull/11476
[dotty_pull_11480]: https://github.com/lampepfl/dotty/pull/11480 "more fixes in Markdown files"
[dotty_pull_11728]: https://github.com/lampepfl/dotty/pull/11728 "more fixes in Markdown files"
