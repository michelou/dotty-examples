/**
  * Implicit Function Types: https://dotty.epfl.ch/docs/reference/contextual/implicit-function-types.html
  * Context Functions: https://dotty.epfl.ch/docs/reference/contextual/context-functions.html
  */
  
import scala.collection.mutable.ArrayBuffer

object ImplicitFunctionTypes {

  class Table {
    val rows = new ArrayBuffer[Row]
    def add(r: Row): Unit = rows += r
    override def toString = rows.mkString("Table(", ", ", ")")
  }

  class Row {
    val cells = new ArrayBuffer[Cell]
    def add(c: Cell): Unit = cells += c
    override def toString = cells.mkString("Row(", ", ", ")")
  }

  case class Cell(elem: String)

  def table(init: Table ?=> Unit) = {
    given t: Table = new Table
    init
    t
  }

  def row(init: Row ?=> Unit)(using t: Table) = {
    given r: Row = new Row
    init
    t.add(r)
  }

  def cell(str: String)(using r: Row) = 
    r.add(new Cell(str))

  def test: Unit = {
    val t = table {
      row {
        cell("top left")
        cell("top right")
      }
      row {
        cell("bottom left")
        cell("bottom right")
      }
    }
    println(t)
  }
}
