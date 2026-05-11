import core/models/hex/grid
import core/models/hex/hex
import gleam/result
import unitest

pub fn grid_new_test() {
  use <- unitest.tags(["unit", "hex_grid", "grid"])
  let assert Ok(_) = grid.new(3)
}

pub fn grid_new_returns_ok_test() {
  use <- unitest.tags(["unit", "hex_grid", "grid"])
  let g = grid.new(3)
  assert result.is_ok(g)
}

pub fn grid_radius_test() {
  use <- unitest.tags(["unit", "hex_grid", "grid"])
  let assert Ok(g) = grid.new(3)
  assert 3 == grid.radius(g)
}

pub fn grid_contains_center_test() {
  use <- unitest.tags(["unit", "hex_grid", "grid"])
  let assert Ok(g) = grid.new(3)
  let assert Ok(center) = hex.new(0, 0)
  assert grid.contains(g, center)
}

pub fn grid_contains_outer_hex_test() {
  use <- unitest.tags(["unit", "hex_grid", "grid"])
  let assert Ok(g) = grid.new(3)
  let assert Ok(outer) = hex.new(3, -3)
  assert grid.contains(g, outer)
}

pub fn grid_does_not_contain_hex_outside_radius_test() {
  use <- unitest.tags(["unit", "hex_grid", "grid"])
  let assert Ok(g) = grid.new(2)
  let assert Ok(outside) = hex.new(3, -3)
  assert !grid.contains(g, outside)
}
