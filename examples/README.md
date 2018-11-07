# Dotty examples

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    The <strong><code>examples\</code></strong> directory contains <a href="http://dotty.epfl.ch/" alt="Dotty">Dotty</a> examples coming from various websites - mostly from the <a href="http://dotty.epfl.ch/">Dotty project</a>.
  </td>
  </tr>
</table>

### `dotty-example-project`

*(see [dotty-example-project](https://github.com/lampepfl/dotty-example-project) on Dotty Github)*

This project covers [Dotty](http://dotty.epfl.ch/) features such as trait parameters, enum types, implicit functions, implicit parameters, implicit conversions, union types, and so on.

### `enum-Color`

*(see example in [Dotty Documentation](http://dotty.epfl.ch/docs/reference/enums/enums.html))*

Executing the [**`build`**](enum-Color/build.bat) command in directory [**`examples\enum-Color\`**](enum-Color/) prints the following output:
<pre style="font-size:80%;">
> build clean compile run
Green
3
5
Green
3
</pre>

### `enum-HList`

Executing the [**`build`**](enum-HList/build.bat) command in directory [**`examples\enum-HList\`**](enum-HList/) prints no output since all assertions succeed:

<pre style="font-size:80%;">
> build clean compile run
</pre>

### `enum-Java`

Executing the [**`build`**](enum-Java/build.bat) command in directory [**`examples\enum-Java\`**](enum-Java/) prints the following output:
<pre style="font-size:80%;">
> build clean compile run
SUNDAY
A
SUNDAY
</pre>

### `enum-Planet`

*(see example in [Dotty Documentation](http://dotty.epfl.ch/docs/reference/enums/enums.html))*

Executing the [**`build`**](enum-Planet/build.bat) command in directory [**`examples\enum-Planet\`**](enum-Planet/) prints the following output:

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
W:\dotty\examples\enum-Planet>
</pre>

**NB.** The `build` command takes the main class name and its arguments from the [**`project\build.properties`**](enum-Planet/project/build.properties) configuration file.

<pre style="font-size:80%;">
sbt.version=1.2.1

main.class=Planet
main.args=1
</pre>

Executing the `sbt` command in directory [**`examples\enum-Planet\`**](enum-Planet/) prints the following output:

<pre style="font-size:80%;">
> sbt clean compile "run 1"
[warn] Executing in batch mode.
...
[info] Done updating.
[info] Compiling 1 Scala source to W:\dotty\examples\enum-Planet\target\scala-0.9\classes...
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

Executing the [**`build`**](enum-Tree/build.bat) command in directory [**`examples\enum-Tree\`**](enum-Tree) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
If(IsZero(Pred(Succ(Zero))),Succ(Succ(Zero)),Pred(Pred(Zero))) --> 2
</pre>

### `hello-scala`

Executing the [**`build`**](hello-scala/build.bat) command in directory [**`examples\hello-scala\`**](hello-scala/) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
Hello!
Java Hello!
</pre>

### `ImplicitFunctionTypes`

Executing the [**`build`**](ImplicitFunctionTypes/build.bat) command in directory [**`examples\ImplicitFunctionTypes\`**](ImplicitFunctionTypes/) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
Table(Row(Cell(top left), Cell(top right)), Row(Cell(bottom left), Cell(bottom right)))
</pre>

### `IntersectionTypes`

Executing the [**`build`**](IntersectionTypes/build.bat) command in directory [**`examples\IntersectionTypes\`**](IntersectionTypes/) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
Buffer(first)
</pre>

### `PatternMatching`

Executing the [**`build`**](PatternMatching/build.bat) command in directory [**`examples\PatternMatching\`**](PatternMatching/) prints the following output:
<pre style="font-size:80%;">
> build clean compile run
even has an even number of characters
First: H; Second: i
e,x,a,m
5 is a natural number
List(3, 4)
</pre>

### `TypeLambdas-Underscore`

Executing the [**`build`**](TypeLambdas-Underscore/build.bat) command in directory [**`examples\TypeLambdas-Underscore\`**](TypeLambdas-Underscore/) prints the following output:
<pre style="font-size:80%;">
> build clean compile run
Type Aliases example:
11
11
11

Functors example:
functorForOption: Some(1)
Some(-1)
functorForList: List(Some(1), None, Some(2))
functorForList: List(None, Some(2))
functorForList: List(Some(2))
functorForList: List()
List(1, 0, 2)
</pre>

### `UnionTypes`

Executing the [**`build`**](UnionTypes/build.bat) command in directory [**`examples\UnionTypes\`**](UnionTypes/) prints the following output:
<pre style="font-size:80%;">
> build clean compile run
either=UserName(Eve)
</pre>

*[mics](http://lampwww.epfl.ch/~michelou/)/April 2018*






