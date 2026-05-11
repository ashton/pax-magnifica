import core/models/hex/hex
import core/models/hex/ring
import gleam/list
import gleam/result
import unitest

pub fn create_test() {
  use <- unitest.tags(["unit", "hex_grid", "ring"])
  assert ring.create(radius: 2) |> result.is_ok()
}

pub fn radius_test() {
  use <- unitest.tags(["unit", "hex_grid", "ring"])
  let assert Ok(r) = ring.create(radius: 2)

  assert 2 == ring.radius(r)
}

pub fn ring_radius_zero_test() {
  use <- unitest.tags(["unit", "hex_grid", "ring"])
  let assert Ok(expected) = hex.new(0, 0)

  let assert Ok(subject) = ring.create(radius: 0)
  assert [expected] == ring.items(subject)
}

pub fn ring_radius_one_test() {
  use <- unitest.tags(["unit", "hex_grid", "ring"])
  let assert Ok(expectation) =
    [#(-1, 0), #(-1, 1), #(0, -1), #(0, 1), #(1, -1), #(1, 0)]
    |> list.map(hex.from_pair)
    |> result.all()

  let is_contained = list.contains(expectation, _)

  let assert Ok(subject) = ring.create(radius: 1)

  assert subject
    |> ring.items()
    |> list.all(is_contained)
}

// BUG: build_ring stores hexes in a Set, so ring.items for radius >= 2 returns
// hexes in Erlang term-sorted order (col then row) instead of the clockwise
// order that ring.create(1) produces via dict.to_list on direction indices.
// This test asserts the expected clockwise order and fails because of that bug.
pub fn ring_radius_two_clockwise_order_test() {
  use <- unitest.tags(["unit", "hex_grid", "ring"])
  let assert Ok(expectation) =
    [
      #(0, -2),
      #(1, -2),
      #(2, -2),
      #(2, -1),
      #(2, 0),
      #(1, 1),
      #(0, 2),
      #(-1, 2),
      #(-2, 2),
      #(-2, 1),
      #(-2, 0),
      #(-1, -1),
    ]
    |> list.map(hex.from_pair)
    |> result.all()

  let assert Ok(subject) = ring.create(radius: 2)

  assert expectation == ring.items(subject)
}
