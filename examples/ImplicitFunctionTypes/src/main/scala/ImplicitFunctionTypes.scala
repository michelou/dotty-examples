/**
  * Implicit Function Types: https://dotty.epfl.ch/docs/reference/contextual/implicit-function-types.html
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

  def table(init: (given Table) => Unit) = {
    given t: Table
    init
    t
  }

  def row(init: (given Row) => Unit)(given t: Table) = {
    given r: Row
    init
    t.add(r)
  }

  def cell(str: String)(given r: Row) = 
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
