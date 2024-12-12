import core/models/hex/coordinate
import core/models/hex/ring
import glacier
import glacier/should

pub fn main() {
  glacier.main()
}

pub fn new_and_ring_number_test() {
  ring.new(0, [coordinate.new(0, 0)])
  |> ring.number()
  |> should.equal(0)
}

pub fn ring_coordinates_test() {
  ring.new(0, [coordinate.new(0, 0)])
  |> ring.coordinates()
  |> should.equal([coordinate.new(0, 0)])
}
