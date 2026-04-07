import core/models/hex/vector.{type Vector}
import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/result

pub opaque type Hex {
  Hex(col: Int, row: Int)
}

pub fn directions() {
  [
    #(0, vector.new(0, -1, 1)),
    #(1, vector.new(1, -1, 0)),
    #(2, vector.new(1, 0, -1)),
    #(3, vector.new(0, 1, -1)),
    #(4, vector.new(-1, 1, 0)),
    #(5, vector.new(-1, 0, 1)),
  ]
  |> dict.from_list()
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
  directions()
  |> dict.to_list
  |> list.map(fn(pair) {
    let #(_, val) = pair
    val
  })
  |> list.map(result.try(_, add(origin_hex, _)))
  |> list.map(with: result.try(_, from_vector))
  |> result.all()
}

pub fn rotate_clockwise(subject: Hex, around center: Hex) -> Result(Hex, String) {
  use subject_vec <- result.try(to_vector(subject))
  use center_vec <- result.try(to_vector(center))

  let relative = vector.subtract(subject_vec, center_vec)
  let #(x, y, z) = vector.to_triplet(relative)

  // Clockwise 60° rotation in cube coordinates: (x, y, z) → (-y, -z, -x)
  use rotated <- result.try(vector.new(-y, -z, -x))

  rotated
  |> vector.add(center_vec)
  |> from_vector()
}

pub fn rotate_counter_clockwise(
  subject: Hex,
  around center: Hex,
) -> Result(Hex, String) {
  use subject_vec <- result.try(to_vector(subject))
  use center_vec <- result.try(to_vector(center))

  let relative = vector.subtract(subject_vec, center_vec)
  let #(x, y, z) = vector.to_triplet(relative)

  // Counter-clockwise 60° rotation in cube coordinates: (x, y, z) → (-z, -x, -y)
  use rotated <- result.try(vector.new(-z, -x, -y))

  rotated
  |> vector.add(center_vec)
  |> from_vector()
}

pub fn distance(one: Hex, other: Hex) -> Result(Int, String) {
  other
  |> to_vector()
  |> result.try(subtract(one, _))
  |> result.try(fn(res: Vector) {
    let #(vcol, vrow, vdiag) = res |> vector.to_triplet()
    let col_abs = vcol |> int.absolute_value()
    let row_abs = vrow |> int.absolute_value()
    let diag_abs = vdiag |> int.absolute_value()

    { col_abs + diag_abs + row_abs }
    |> int.divide(2)
    |> result.replace_error("Unable to calculate distance")
  })
}
