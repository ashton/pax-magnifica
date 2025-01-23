import gleam/bool

pub opaque type Vector {
  Vector(col: Int, row: Int, diagonal: Int)
}

pub const vector_directions = [
  Vector(0, -1, 1),
  Vector(1, -1, 0),
  Vector(1, 0, -1),
  Vector(0, 1, -1),
  Vector(-1, 1, 0),
  Vector(-1, 0, 1),
]

pub fn new(col: Int, row: Int, diagonal: Int) -> Result(Vector, String) {
  case col + row + diagonal {
    0 -> Vector(col:, row:, diagonal:) |> Ok
    _ -> Error("invalid hex coordinates")
  }
}

pub fn equal(v1: Vector, v2: Vector) -> Bool {
  let Vector(col: col1, row: row1, diagonal: diag1) = v1
  let Vector(col: col2, row: row2, diagonal: diag2) = v2

  bool.and({ col1 == col2 }, { row1 == row2 })
  |> bool.and({ diag1 == diag2 })
}

pub fn from_triplet(subject: #(Int, Int, Int)) -> Result(Vector, String) {
  let #(col, row, diagonal) = subject
  new(col, row, diagonal)
}

pub fn to_triplet(vec: Vector) -> #(Int, Int, Int) {
  let Vector(col:, row:, diagonal:) = vec
  #(col, row, diagonal)
}

pub fn rotate_clockwise(vec) -> Vector {
  let Vector(col:, row:, diagonal:) = vec

  Vector(col: col + diagonal, row: row + col, diagonal: diagonal + row)
}

pub fn rotate_counter_clockwise(vec) -> Vector {
  let Vector(col:, row:, diagonal:) = vec
  Vector(col: col + row, row: row + diagonal, diagonal: diagonal + col)
}

pub fn scale(vec: Vector, factor: Int) -> Vector {
  let Vector(col:, row:, diagonal:) = vec
  Vector(col: col * factor, row: row * factor, diagonal: diagonal * factor)
}

pub fn reduce(vec: Vector, factor: Int) -> Vector {
  let Vector(col:, row:, diagonal:) = vec
  Vector(col: col / factor, row: row / factor, diagonal: diagonal / factor)
}

pub fn subtract(one: Vector, other: Vector) -> Vector {
  Vector(
    col: one.col - other.col,
    row: one.row - other.row,
    diagonal: one.diagonal - other.diagonal,
  )
}

pub fn add(one: Vector, other: Vector) -> Vector {
  Vector(
    col: one.col + other.col,
    row: one.row + other.row,
    diagonal: one.diagonal + other.diagonal,
  )
}
