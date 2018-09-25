# Dotty examples

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" width="120"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    The <strong><code>myexamples\</code></strong> directory contains <a href="http://dotty.epfl.ch/" alt="Dotty">Dotty</a> code examples written by myself.
  </td>
  </tr>
</table>

### `00_AutoParamTupling`

Executing the [**`build`**](00_AutoParamTupling/build.bat) command in directory [**`myexamples\00_AutoParamTupling\`**](00_AutoParamTupling/) 
prints the following output:

<pre style="font-size:80%;">
> build clean compile run
: d : o : t : t : y
0: d 1: o 2: t 3: t 4: y
0,-1: d 1,-2: o 2,-3: t 3,-4: t 4,-5: y
0,-1: d 1,-2: o 2,-3: t 3,-4: t 4,-5: y
0,-1: d 1,-2: o 2,-3: t 3,-4: t 4,-5: y
</pre>

### `01_Dependent_Types`

Executing the [**`build`**](01_Dependent_Types/build.bat) command in directory [**`myexamples\01_Dependent_Types\`**](01_Dependent_Types/) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
params=Map(grade -> C, sort -> time, width -> 120)
</pre>

### `02_Union_Types`

Executing the [**`build`**](02_Union_Types/build.bat) command in directory [**`myexamples\02_Union_Types\`**](02_Union_Types/) prints the following output:

<pre style="font-size:80%;">
> build -timer clean compile run
Compile time: 00:00:05
testIntFloat example:
Float 0.0
Int 4

testDivision example:
Success(0.5)
DivisionByZero
0.5
Division failed

testMessage example:
https://www.google.com
Dotty

testJSON example:
1
[1, "abc", true]
{a: 1, b: "blue", c: [1, "abc", true]}
</pre>

### `03_Intersection_Types`

Executing the [**`build`**](03_Intersection_Types/build.bat) command in directory [**`myexamples\03_Intersection_Types\`**](03_Intersection_Types/) prints the following output:

<pre style="font-size:80%;">
> build clean compile run
Buffer(1,2,3,4)
</pre>

### `04_Multiversal_Equality`

Executing the [**`build`**](04_Multiversal_Equality/build.bat) command in directory [**`myexamples\04_Multiversal_Equality\`**](04_Multiversal_Equality/) prints the following output:

<pre>
> build clean compile run
test1 example:
false
false

test2 example:
false                             
false                             
                                  
testCharInt example:              
false
false
true                              
true                              
                                  
testBooleanChar example:          
true                              
false                             
</pre>

### [`bug4272`](https://github.com/lampepfl/dotty/issues/4272)

Executing the [**`build`**](bug4272/build.bat) command in directory [**`myexamples\bug4272\`**](bug4272/) produces a runtime exception with version 0.7 of the Dotty compiler (*was fixed in version 0.8*):

<pre style="font-size:80%;">
> build clean compile run
exception occurred while typechecking C:\dotty\MYEXAM~1\bug4272\src\main\scala\Main.scala
exception occurred while compiling C:\dotty\MYEXAM~1\bug4272\src\main\scala\Main.scala
Exception in thread "main" java.lang.AssertionError: cannot merge Constraint(
 uninstVars = A;
 constrained types = [A, B](elems: (A, B)*): Map[A, B]
 bounds =
     A >: Char
     B := Boolean
 ordering =
) with Constraint(
 uninstVars = A, Boolean;
 constrained types = [A, B](elems: (A, B)*): Map[A, B]
 bounds =
     A >: String <: String
     B <: Boolean
 ordering =
)
        at dotty.tools.dotc.core.OrderingConstraint.mergeError$1(OrderingConstraint.scala:538)
        ..
        at dotty.tools.dotc.Driver.main(Driver.scala:135)
        at dotty.tools.dotc.Main.main(Main.scala)
</pre>

### [`bug4356`](https://github.com/lampepfl/dotty/issues/4356)

Executing the `build` command in directory **`myexamples\bug4356\`** produces a runtime exception with version 0.7 of the Dotty compiler:

<pre>
> build clean compile
Exception in thread "main" java.nio.file.InvalidPathException: Illegal char <:> at index 72: C:\dotty\MYEXAM~1\bug4356\\lib\junit-4.12.jar:C:\dotty\MYEXAM~1\bug4356\target\dotty-0.7\classes
        at sun.nio.fs.WindowsPathParser.normalize(WindowsPathParser.java:182)
        at sun.nio.fs.WindowsPathParser.parse(WindowsPathParser.java:153)
        at sun.nio.fs.WindowsPathParser.parse(WindowsPathParser.java:77)
        at sun.nio.fs.WindowsPath.parse(WindowsPath.java:94)
        at sun.nio.fs.WindowsFileSystem.getPath(WindowsFileSystem.java:255)
        at java.nio.file.Paths.get(Paths.java:84)
        ...
        at dotty.tools.dotc.Driver.main(Driver.scala:135)
        at dotty.tools.dotc.Main.main(Main.scala)
</pre>

### `HelloWorld`

Executing the [**`build`**](HelloWorld/build.bat) command in directory [**`myexamples\HelloWorld\`**](HelloWorld/) prints the following output:

<pre>
> build clean compile run
Hello world!
</pre>

*[mics](http://lampwww.epfl.ch/~michelou/)/May 2018*






