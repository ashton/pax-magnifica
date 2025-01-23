import core/models/hex/hex
import core/models/hex/vector
import glacier/should
import gleam/list
import gleam/result

pub fn equal_test() {
  let hex1 =
    hex.new(0, 0)
    |> should.be_ok()

  let hex2 =
    hex.new(0, 0)
    |> should.be_ok()

  hex.equal(hex1, hex2)
  |> should.be_true()
}

pub fn from_pair_test() {
  let base_hex =
    hex.new(1, -1)
    |> should.be_ok()

  hex.from_pair(#(1, -1))
  |> should.be_ok()
  |> hex.equal(base_hex)
  |> should.be_true()
}

pub fn to_pair_test() {
  hex.new(1, -1)
  |> should.be_ok()
  |> hex.to_pair()
  |> should.equal(#(1, -1))
}

pub fn to_vector_test() {
  hex.new(1, -1)
  |> should.be_ok()
  |> hex.to_vector()
  |> should.be_ok()
  |> vector.to_triplet()
  |> should.equal(#(1, -1, 0))
}

pub fn from_vector_test() {
  vector.new(1, -1, 0)
  |> should.be_ok()
  |> hex.from_vector()
  |> should.be_ok()
  |> hex.equal(hex.new(1, -1) |> should.be_ok())
  |> should.be_true()
}

pub fn neighbors_test() {
  let subject = hex.new(1, -1) |> should.be_ok()
  let result =
    subject
    |> hex.neighbors()
    |> should.be_ok()

  let expected =
    [
      hex.new(1, -2),
      hex.new(2, -2),
      hex.new(2, -1),
      hex.new(1, 0),
      hex.new(0, 0),
      hex.new(0, -1),
    ]
    |> result.all()
    |> should.be_ok()

  result
  |> list.length()
  |> should.equal(expected |> list.length())

  result
  |> should.equal(expected)
}

pub fn distance_test() {
  let origin = hex.new(0, 0) |> should.be_ok()
  let dest = hex.new(-1, -2) |> should.be_ok()

  origin
  |> hex.distance(dest)
  |> should.be_ok()
  |> should.equal(3)
}
