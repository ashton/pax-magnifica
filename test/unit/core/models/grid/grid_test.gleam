import core/models/hex/grid
import core/models/hex/hex
import core/models/hex/ring
import glacier/should
import gleam/dict
import gleam/list

pub fn grid_new_test() {
  grid.new(3)
  |> should.be_ok()
}

pub fn grid_length_test() {
  grid.new(3)
  |> should.be_ok()
  |> grid.length()
  |> should.equal(4)
}

pub fn grid_rings_test() {
  grid.new(3)
  |> should.be_ok()
  |> grid.rings()
  |> list.length()
  |> should.equal(4)
}

pub fn grid_ring_test() {
  grid.new(3)
  |> should.be_ok()
  |> grid.ring(2)
  |> should.be_some()
  |> ring.radius()
  // zero indexed
  |> should.equal(1)
}

pub fn grid_to_dict_size_0_test() {
  let hex = hex.new(0, 0) |> should.be_ok()
  let expectation =
    dict.new()
    |> dict.insert(#(0, 0), hex)
  grid.new(0)
  |> should.be_ok()
  |> grid.to_dict()
  |> should.equal(expectation)
}

pub fn grid_to_dict_size_1_test() {
  let expectation =
    dict.new()
    |> dict.insert(#(-1, 0), hex.new(-1, 0) |> should.be_ok())
    |> dict.insert(#(-1, 1), hex.new(-1, 1) |> should.be_ok())
    |> dict.insert(#(0, -1), hex.new(0, -1) |> should.be_ok())
    |> dict.insert(#(0, 0), hex.new(0, 0) |> should.be_ok())
    |> dict.insert(#(0, 1), hex.new(0, 1) |> should.be_ok())
    |> dict.insert(#(1, -1), hex.new(1, -1) |> should.be_ok())
    |> dict.insert(#(1, 0), hex.new(1, 0) |> should.be_ok())

  grid.new(1)
  |> should.be_ok()
  |> grid.to_dict()
  |> should.equal(expectation)
}
