import core/models/hex/hex
import core/models/hex/ring
import glacier/should
import gleam/list
import gleam/result

pub fn create_test() {
  ring.create(radius: 2)
  |> should.be_ok()
}

pub fn radius_test() {
  ring.create(radius: 2)
  |> should.be_ok()
  |> ring.radius()
  |> should.equal(2)
}

pub fn ring_radius_zero_test() {
  let expected = hex.new(0, 0) |> should.be_ok()
  ring.create(radius: 0)
  |> should.be_ok()
  |> ring.items()
  |> should.equal([expected])
}

pub fn ring_radius_one_test() {
  let expectation =
    [#(-1, 0), #(-1, 1), #(0, -1), #(0, 1), #(1, -1), #(1, 0)]
    |> list.map(hex.from_pair)
    |> result.all()
    |> should.be_ok()

  let is_contained = list.contains(expectation, _)

  ring.create(radius: 1)
  |> should.be_ok()
  |> ring.items()
  |> list.all(is_contained)
  |> should.be_true()
}

pub fn ring_radius_two_test() {
  let expectation =
    [
      #(-2, 0),
      #(-2, 1),
      #(-2, 2),
      #(-1, -1),
      #(-1, 2),
      #(0, -2),
      #(0, 2),
      #(1, -2),
      #(1, 1),
      #(2, -2),
      #(2, -1),
      #(2, 0),
    ]
    |> list.map(hex.from_pair)
    |> result.all()
    |> should.be_ok()

  ring.create(radius: 2)
  |> should.be_ok()
  |> ring.items()
  |> should.equal(expectation)
}
