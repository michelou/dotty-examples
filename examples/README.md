# Dotty examples

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" style="width:120px;"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <strong><code>examples</code></strong> directory contains Dotty examples coming from various Web sites - including from the <a href="http://dotty.epfl.ch/">Dotty project</a> website.</td>
  </tr>
</table>

### `dotty-example-project`

*(see [dotty-example-project](https://github.com/lampepfl/dotty-example-project) on Dotty Github)*

This project covers Dotty features such as trait parameters, enum types, implicit functions, implicit parameters, implicit conversions, union types, and so on.

### `enum-Color`

*(see example in [Dotty Documentation](http://dotty.epfl.ch/docs/reference/enums/enums.html))*

Executing the `build` command in directory **`examples\enum-Color`** prints the following output:
<pre>
> build compile run
Green
3
5
Green
3
</pre>

### `enum-HList`

Executing the `build` command in directory **`examples\enum-HList`** prints no output since all assertions succeed:

<pre>
> build compile run
>
</pre>

### `enum-Planet`

*(see example in [Dotty Documentation](http://dotty.epfl.ch/docs/reference/enums/enums.html))*

Executing the `build` command in directory **`examples\enum-Planet`** prints the following output:

<pre>
> build -timer clean compile run
Compile time: 00:00:05
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
C:\dotty\examples\enum-Planet>
</pre>

Executing the `sbt` command in directory **`examples\enum-Planet`** prints the following output:

<pre>
> sbt clean compile "run 1"
[warn] Executing in batch mode.
...
[info] Done updating.
[info] Compiling 1 Scala source to C:\dotty\examples\enum-Planet\target\scala-0.7\classes...
[success] Total time: 4 s, completed 14 avr. 2018 21:36:42
[info] Running Planet 1
Your weight on MERCURY is 0.37775761520093526
Your weight on SATURN is 1.0660155388115666
Your weight on VENUS is 0.9049990998410455
Your weight on URANUS is 0.9051271993894251
Your weight on EARTH is 0.9999999999999999
Your weight on NEPTUNE is 1.1383280724696578
Your weight on MARS is 0.37873718403712886
Your weight on JUPITER is 2.5305575254957406
[success] Total time: 0 s, completed 14 avr. 2018 21:36:42
</pre>

### `enum-Tree`

Executing the `build` command in directory **`examples\enum-Tree`** prints the following output:

<pre>
> build clean compile run
If(IsZero(Pred(Succ(Zero))),Succ(Succ(Zero)),Pred(Pred(Zero))) --> 2
</pre>

*mics/April 2018*






