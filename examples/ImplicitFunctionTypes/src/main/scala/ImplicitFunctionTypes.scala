/**
  * Implicit Function Types: http://dotty.epfl.ch/docs/reference/implicit-function-types.html
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

  def table(init: implicit Table => Unit) = {
    implicit val t = new Table
    init
    t
  }

  def row(init: implicit Row => Unit)(implicit t: Table) = {
    implicit val r = new Row
    init
    t.add(r)
  }

  def cell(str: String)(implicit r: Row) = 
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
