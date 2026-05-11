import core/models/hex/hex
import core/models/hex/vector
import gleam/list
import gleam/result
import unitest

pub fn equal_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex"])
  let assert Ok(hex1) = hex.new(0, 0)
  let assert Ok(hex2) = hex.new(0, 0)

  assert hex.equal(hex1, hex2)
}

pub fn from_pair_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex"])
  let assert Ok(base_hex) = hex.new(1, -1)

  let assert Ok(hex_from_pair) = hex.from_pair(#(1, -1))
  assert hex.equal(base_hex, hex_from_pair)
}

pub fn to_pair_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex"])
  let assert Ok(subject) = hex.new(1, -1)
  assert #(1, -1) == hex.to_pair(subject)
}

pub fn to_vector_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex"])
  let assert Ok(subject) = hex.new(1, -1)
  let assert Ok(vec) = hex.to_vector(subject)
  assert #(1, -1, 0) == vector.to_triplet(vec)
}

pub fn from_vector_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex"])
  let assert Ok(vec) = vector.new(1, -1, 0)
  let assert Ok(subject) = hex.from_vector(vec)
  let assert Ok(expectation) = hex.new(1, -1)

  assert hex.equal(expectation, subject)
}

pub fn neighbors_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex"])
  let assert Ok(subject) = hex.new(1, -1)
  let assert Ok(result) = subject |> hex.neighbors()

  let assert Ok(expected) =
    [
      hex.new(1, -2),
      hex.new(2, -2),
      hex.new(2, -1),
      hex.new(1, 0),
      hex.new(0, 0),
      hex.new(0, -1),
    ]
    |> result.all()

  assert list.length(expected) == list.length(result)
  assert expected == result
}

pub fn distance_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex"])
  let assert Ok(origin) = hex.new(0, 0)
  let assert Ok(dest) = hex.new(-1, -2)

  let assert Ok(distance) =
    origin
    |> hex.distance(dest)

  assert 3 == distance
}
