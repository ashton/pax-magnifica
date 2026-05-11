import core/models/hex/vector
import unitest

pub fn equal_test() {
  use <- unitest.tags(["unit", "hex_grid", "vector"])
  let assert Ok(v1) = vector.new(0, 0, 0)
  let assert Ok(v2) = vector.new(0, 0, 0)

  assert vector.equal(v1, v2)
}

pub fn from_triplet_test() {
  use <- unitest.tags(["unit", "hex_grid", "vector"])
  let assert Ok(v1) = #(0, 0, 0) |> vector.from_triplet()
  let assert Ok(v2) = vector.new(0, 0, 0)

  assert vector.equal(v1, v2)
}

pub fn to_triplet_test() {
  use <- unitest.tags(["unit", "hex_grid", "vector"])
  let assert Ok(subject) = vector.new(0, 0, 0)

  assert #(0, 0, 0) == vector.to_triplet(subject)
}

pub fn scale_test() {
  use <- unitest.tags(["unit", "hex_grid", "vector"])
  let assert Ok(subject) = vector.new(-2, 2, 0)

  let res = subject |> vector.scale(2)

  let assert Ok(expectation) = vector.new(-4, 4, 0)
  assert expectation == res
}
