import core/models/hex/vector.{type Vector}
import gleam/bool
import gleam/int
import gleam/list
import gleam/result

pub opaque type Hex {
  Hex(col: Int, row: Int)
}

fn diagonal(col, row) -> Int {
  -col - row
}

fn diagonal_from_hex(hex: Hex) -> Int {
  diagonal(hex.col, hex.row)
}

pub fn new(col: Int, row: Int) -> Result(Hex, String) {
  case col + row + diagonal(col, row) {
    0 -> Hex(col, row) |> Ok
    _ -> Error("invalid hex coordinates")
  }
}

pub fn from_vector(vec: Vector) -> Result(Hex, String) {
  let #(col, row, _) = vec |> vector.to_triplet()

  new(col, row)
}

pub fn to_vector(subject: Hex) -> Result(Vector, String) {
  let Hex(col:, row:) = subject
  let diag = diagonal(col, row)

  vector.new(col, row, diag)
}

pub fn from_pair(p: #(Int, Int)) -> Result(Hex, String) {
  let #(col, row) = p
  new(col, row)
}

pub fn to_pair(hex: Hex) -> #(Int, Int) {
  #(hex.col, hex.row)
}

pub fn equal(hex1 one: Hex, hex2 other: Hex) -> Bool {
  bool.and(one.col == other.col, one.row == other.row)
}

pub fn add(subject: Hex, vec: Vector) -> Result(Vector, String) {
  let diag = diagonal_from_hex(subject)
  let #(vcol, vrow, vdiag) = vector.to_triplet(vec)
  vector.new(subject.col + vcol, subject.row + vrow, diag + vdiag)
}

pub fn subtract(subject: Hex, vec: Vector) -> Result(Vector, String) {
  let diag = diagonal_from_hex(subject)
  let #(vcol, vrow, vdiag) = vector.to_triplet(vec)
  vector.new(subject.col - vcol, subject.row - vrow, diag - vdiag)
}

pub fn neighbors(origin_hex: Hex) -> Result(List(Hex), String) {
  vector.vector_directions
  |> list.map(add(origin_hex, _))
  |> list.map(with: result.then(_, from_vector))
  |> result.all()
}

pub fn distance(one: Hex, other: Hex) -> Result(Int, String) {
  other
  |> to_vector()
  |> result.then(subtract(one, _))
  |> result.then(fn(res: Vector) {
    let #(vcol, vrow, vdiag) = res |> vector.to_triplet()
    let col_abs = vcol |> int.absolute_value()
    let row_abs = vrow |> int.absolute_value()
    let diag_abs = vdiag |> int.absolute_value()

    { col_abs + diag_abs + row_abs }
    |> int.divide(2)
    |> result.replace_error("Unable to calculate distance")
  })
}
