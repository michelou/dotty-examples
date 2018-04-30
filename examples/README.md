# Dotty examples

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <strong><code>examples\</code></strong> directory contains <a href="http://dotty.epfl.ch/" alt="Dotty">Dotty</a> examples coming from various websites - mostly from the <a href="http://dotty.epfl.ch/">Dotty project</a>.</td>
  </tr>
</table>

### `dotty-example-project`

*(see [dotty-example-project](https://github.com/lampepfl/dotty-example-project) on Dotty Github)*

This project covers [Dotty](http://dotty.epfl.ch/) features such as trait parameters, enum types, implicit functions, implicit parameters, implicit conversions, union types, and so on.

### `enum-Color`

*(see example in [Dotty Documentation](http://dotty.epfl.ch/docs/reference/enums/enums.html))*

Executing the `build` command in directory **`examples\enum-Color\`** prints the following output:
<pre style="font-size:80%;">
> build clean compile run
Green
3
5
Green
3
</pre>

### `enum-HList`

Executing the `build` command in directory **`examples\enum-HList\`** prints no output since all assertions succeed:

<pre style="font-size:80%;">
> build clean compile run
>
</pre>

### `enum-Planet`

*(see example in [Dotty Documentation](http://dotty.epfl.ch/docs/reference/enums/enums.html))*

Executing the `build` command in directory **`examples\enum-Planet\`** prints the following output:

<pre style="font-size:80%;">
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

**NB.** The `build`command takes the main class name and its arguments from the **`project\build.properties`** configuration file.

<pre style="font-size:80%;">
sbt.version=1.1.4

main.class=Planet
main.args=1
</pre>

Executing the `sbt` command in directory **`examples\enum-Planet\`** prints the following output:

<pre style="font-size:80%;">
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

Executing the `build` command in directory **`examples\enum-Tree\`** prints the following output:

<pre style="font-size:80%;">
> build clean compile run
If(IsZero(Pred(Succ(Zero))),Succ(Succ(Zero)),Pred(Pred(Zero))) --> 2
</pre>

### `ImplicitFunctionTypes`

Executing the `build` command in directory **`examples\ImplicitFunctionTypes\`** prints the following output:

<pre style="font-size:80%;">
> build clean compile run
Table(Row(Cell(top left), Cell(top right)), Row(Cell(bottom left), Cell(bottom right)))
</pre>

### `IntersectionTypes`

Executing the `build` command in directory **`examples\IntersectionTypes\`** prints the following output:

<pre style="font-size:80%;">
> build clean compile run
Buffer(first)
</pre>

*[mics](http://lampwww.epfl.ch/~michelou/)/April 2018*






