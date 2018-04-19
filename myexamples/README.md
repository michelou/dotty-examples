# Dotty examples

<table style="font-family:Helvetica,Arial;font-size:14px;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="http://dotty.epfl.ch/"><img src="https://www.cakesolutions.net/hubfs/dotty.png" style="width:120px;"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">The <strong><code>myexamples</code></strong> directory contains Dotty examples written by myself.</td>
  </tr>
</table>

### `00_AutoParamTupling`

Executing the `build` command in directory **`myexamples\00_AutoParamTupling`** 
prints the following output:

<pre>
> build clean compile run
: d : o : t : t : y
0: d 1: o 2: t 3: t 4: y
0,-1: d 1,-2: o 2,-3: t 3,-4: t 4,-5: y
0,-1: d 1,-2: o 2,-3: t 3,-4: t 4,-5: y
0,-1: d 1,-2: o 2,-3: t 3,-4: t 4,-5: y
</pre>

### `01_Dependent_Types`

Executing the `build` command in directory **`myexamples\01_Dependent_Types`** prints the following output:
<pre>
> build clean compile run
params=Map(grade -> C, sort -> time, width -> 120)
</pre>

### `02_Union_Types`

Executing the `build` command in directory **`myexamples\02_Union_Types`** prints the following output:

<pre>
> build -timer clean compile run
Compile time: 00:00:06
testIntFloat example:
Float 0.0
Int 4

testMessage example:
https://www.google.com
Dotty

testJSON example:
1
[1, "abc", true]
{a: 1, b: "blue", c: [1, "abc", true]}
</pre>

### `03_Intersection_Types`

Executing the `build`command in directory **`myexamples\03_Intersection_Types`** prints the following output:

<pre>
> build clean compile run
Buffer(1,2,3,4)
</pre>

### `04_Multiversal_Equality`

Executing the `build`command in directory **`myexamples\04_Multiversal_Equality`** prints the following output:

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

### `bug4272`

Executing the `build` command in directory **`myexamples\bug4272`** produces a runtime exception with version 0.7 of the Dotty compiler:

<pre>
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

### `HelloWorld`

Executing the `build` command in directory **`myexamples\HelloWorld`** prints the following output:

<pre>
> build clean compile run
Hello world!
</pre>

*mics/April 2018*






