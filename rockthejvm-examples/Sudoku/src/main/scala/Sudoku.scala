object Sudoku {

  type Board = Array[Array[Int]]

  def prettyString(sudoku: Board): String = {
    sudoku.grouped(3).map { bigGroup =>
      bigGroup.map { row =>
        row.grouped(3).map { smallGroup =>
          smallGroup.mkString(" ", " ", " ")
        }.mkString("|", "|", "|")
      }.mkString("\n")
    }.mkString("+-------+-------+-------+\n", "\n+-------+-------+-------+\n", "\n+-------+-------+-------+")
  }

  def validate(sudoku: Board, x: Int, y: Int, value: Int): Boolean = {
    val row = sudoku(y)
    val rowProperty = !row.contains(value)

    val column = sudoku.map(r => r.apply(x))
    val columnProperty = !column.contains(value)

    val boxX = x / 3
    val boxY = y / 3
    val box = for {
      yb <- (boxY * 3) until (boxY * 3 + 3) // indices for rows in THIS box
      xb <- (boxX * 3) until (boxX * 3 + 3) // same for cols
    } yield sudoku(yb)(xb)
    val boxProperty = !box.contains(value)

    //println(s"cell($x, $y) = $value : row=$rowProperty, column=$columnProperty, box=$boxProperty")
    rowProperty && columnProperty && boxProperty
  }

  def solve(sudoku: Board, x: Int = 0, y: Int = 0): Unit = {
    if (y >= 9) println(prettyString(sudoku)) // final solution
    else if (x >= 9) solve(sudoku, 0, y + 1) // need to fill in the next row
    else if (sudoku(y)(x) > 0) solve(sudoku, x + 1, y) // need to fill in the next cell (cell to the right)
    else (1 to 9).filter(value => validate(sudoku, x, y, value)).foreach { value =>
      // fill the sudoku board with the value
      sudoku(y)(x) = value
      // try the next cell
      solve(sudoku, x + 1, y)
      // remove the value
      sudoku(y)(x) = 0
    }
  }

  def validate2(sudoku: Board, x: Int, y: Int, value: Int): Boolean = {
    val row = sudoku(y)
    // If the row already contains the value we’re trying to fill,
    // the value is invalid for this board configuration.
    if row.contains(value) then return false

    val column = sudoku.map(r => r.apply(x))
    // If the column already contains the value we’re trying to fill,
    // the value is invalid for this board configuration.
    if column.contains(value) then return false

    val boxX = x / 3
    val boxY = y / 3
    val box = for {
      yb <- (boxY * 3) until (boxY * 3 + 3) // indices for rows in THIS box
      xb <- (boxX * 3) until (boxX * 3 + 3) // same for cols
    } yield sudoku(yb)(xb)
    !box.contains(value)
  }

  def solve2(sudoku: Board, x: Int = 0, y: Int = 0): Unit = {
    if (y >= 9) println(prettyString(sudoku)) // final solution
    else if (x >= 9) solve(sudoku, 0, y + 1) // need to fill in the next row
    else if (sudoku(y)(x) > 0) solve(sudoku, x + 1, y) // need to fill in the next cell (cell to the right)
    else (1 to 9).filter(value => validate2(sudoku, x, y, value)).foreach { value =>
      // fill the sudoku board with the value
      sudoku(y)(x) = value
      // try the next cell
      solve(sudoku, x + 1, y)
      // remove the value
      sudoku(y)(x) = 0
    }
  }

  val problem = // see test/scala/SudokuJunitTest.scala
    Array(
      Array(5,3,0, 0,7,0, 0,0,0),
      Array(6,0,0, 1,9,5, 0,0,0),
      Array(0,9,8, 0,0,0, 0,6,0),
      Array(8,0,0, 0,6,0, 0,0,3),
      Array(4,0,0, 8,0,3, 0,0,1),
      Array(7,0,0, 0,2,0, 0,0,6),
      Array(0,6,0, 0,0,0, 2,8,0),
      Array(0,0,0, 4,1,9, 0,0,5),
      Array(0,0,0, 0,8,0, 0,7,9),
    )

  def main(args: Array[String]): Unit = {
    println(prettyString(problem))
    solve(problem)
    solve2(problem)
  }

}
