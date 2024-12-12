import core/models/hex/coordinate

import glacier
import glacier/should

pub fn main() {
  glacier.main()
}

pub fn new_and_to_pair_test() {
  coordinate.new(1, 3)
  |> coordinate.to_pair()
  |> should.equal(#(1, 3))

  coordinate.new(0, 0)
  |> coordinate.to_pair()
  |> should.equal(#(0, 0))

  coordinate.new(-3, -8)
  |> coordinate.to_pair()
  |> should.equal(#(-3, -8))
}

pub fn coord_from_pair_test() {
  coordinate.from_pair(#(1, 3))
  |> should.equal(coordinate.new(1, 3))

  coordinate.from_pair(#(0, 0))
  |> should.equal(coordinate.new(0, 0))

  coordinate.from_pair(#(-3, -8))
  |> should.equal(coordinate.new(-3, -8))
}
