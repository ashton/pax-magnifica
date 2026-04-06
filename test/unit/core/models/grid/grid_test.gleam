import core/models/hex/grid
import core/models/hex/hex
import core/models/hex/ring
import gleam/dict
import gleam/list
import gleam/option.{Some}
import gleam/result

pub fn grid_new_test() {
  let assert Ok(_) = grid.new(3)
}

pub fn grid_length_test() {
  let g = grid.new(3)
  assert result.is_ok(g)
}

pub fn grid_rings_test() {
  let assert Ok(g) = grid.new(3)
  assert 4 == grid.rings(g) |> list.length()
}

pub fn grid_ring_test() {
  let assert Ok(g) = grid.new(3)
  let assert Some(r) = grid.ring(g, 2)

  assert 1 == ring.radius(r)
}

pub fn grid_to_dict_size_0_test() {
  let assert Ok(h) = hex.new(0, 0)
  let expectation =
    dict.new()
    |> dict.insert(#(0, 0), h)

  let assert Ok(new_grid) = grid.new(0)
  assert grid.to_dict(new_grid) == expectation
}

pub fn grid_to_dict_size_1_test() {
  let expectation_result = {
    use h1 <- result.try(hex.new(-1, 0))
    use h2 <- result.try(hex.new(-1, 1))
    use h3 <- result.try(hex.new(0, -1))
    use h4 <- result.try(hex.new(0, 0))
    use h5 <- result.try(hex.new(0, 1))
    use h6 <- result.try(hex.new(1, -1))
    use h7 <- result.try(hex.new(1, 0))

    dict.new()
    |> dict.insert(#(-1, 0), h1)
    |> dict.insert(#(-1, 1), h2)
    |> dict.insert(#(0, -1), h3)
    |> dict.insert(#(0, 0), h4)
    |> dict.insert(#(0, 1), h5)
    |> dict.insert(#(1, -1), h6)
    |> dict.insert(#(1, 0), h7)
    |> Ok()
  }

  let assert Ok(expectation) = expectation_result
  let assert Ok(test_subject) = grid.new(1)
  assert grid.to_dict(test_subject) == expectation
}
