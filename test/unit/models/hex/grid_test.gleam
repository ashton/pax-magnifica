import core/models/hex/grid
import glacier
import glacier/should
import gleam/dict
import gleam/list

pub fn main() {
  glacier.main()
}

pub fn new_and_to_dict_with_only_center_test() {
  grid.new(0)
  |> should.be_ok()
  |> grid.to_dict()
  |> dict.get(0)
  |> should.be_ok()
  |> should.equal([#(0, 0)])
}

pub fn new_grid_and_to_dict_with_first_ring_test() {
  let ring1_coord_pairs = [
    #(0, -1),
    #(1, -1),
    #(1, 0),
    #(0, 1),
    #(-1, 1),
    #(-1, 0),
  ]

  grid.new(1)
  |> should.be_ok()
  |> grid.to_dict()
  |> dict.get(1)
  |> should.be_ok()
  |> should.equal(ring1_coord_pairs)
}

pub fn new_grid_and_to_dict_with_two_ring_test() {
  let ring2_coord_pairs = [
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

  grid.new(2)
  |> should.be_ok()
  |> grid.to_dict()
  |> dict.get(2)
  |> should.be_ok()
  |> should.equal(ring2_coord_pairs)
}

pub fn new_grid_and_to_dict_with_3_ring_test() {
  let ring3_coord_pairs = [
    #(0, -3),
    #(1, -3),
    #(2, -3),
    #(3, -3),
    #(3, -2),
    #(3, -1),
    #(3, 0),
    #(2, 1),
    #(1, 2),
    #(0, 3),
    #(-1, 3),
    #(-2, 3),
    #(-3, 3),
    #(-3, 2),
    #(-3, 1),
    #(-3, 0),
    #(-2, -1),
    #(-1, -2),
  ]

  grid.new(3)
  |> should.be_ok()
  |> grid.to_dict()
  |> dict.get(3)
  |> should.be_ok()
  |> should.equal(ring3_coord_pairs)
}

pub fn new_grid_and_to_dict_with_4_ring_test() {
  let ring4_coord_pairs = [
    #(0, -4),
    #(1, -4),
    #(2, -4),
    #(3, -4),
    #(4, -4),
    #(4, -3),
    #(4, -2),
    #(4, -1),
    #(4, 0),
    #(3, 1),
    #(2, 2),
    #(1, 3),
    #(0, 4),
    #(-1, 4),
    #(-2, 4),
    #(-3, 4),
    #(-4, 4),
    #(-4, 3),
    #(-4, 2),
    #(-4, 1),
    #(-4, 0),
    #(-3, -1),
    #(-2, -2),
    #(-1, -3),
  ]

  grid.new(4)
  |> should.be_ok()
  |> grid.to_dict()
  |> dict.get(4)
  |> should.be_ok()
  |> should.equal(ring4_coord_pairs)
}

pub fn new_grid_invalid_rings_test() {
  grid.new(5)
  |> should.be_error()
  |> should.equal("Invalid amount of rings. It should be >= 0 and <= 4")
}

pub fn new_grid_length_test() {
  let assert Ok(result0) = grid.new(0)
  let assert Ok(result1) = grid.new(1)
  let assert Ok(result2) = grid.new(2)
  let assert Ok(result3) = grid.new(3)
  let assert Ok(result4) = grid.new(4)

  result0
  |> grid.length()
  |> should.equal(1)

  result1
  |> grid.length()
  |> should.equal(2)

  result2
  |> grid.length()
  |> should.equal(3)

  result3
  |> grid.length()
  |> should.equal(4)

  result4
  |> grid.length()
  |> should.equal(5)
}

pub fn rings_test() {
  let assert Ok(result0) = grid.new(0)
  let assert Ok(result1) = grid.new(1)
  let assert Ok(result2) = grid.new(2)
  let assert Ok(result3) = grid.new(3)
  let assert Ok(result4) = grid.new(4)

  result0
  |> grid.rings()
  |> list.length()
  |> should.equal(1)

  result1
  |> grid.rings()
  |> list.length()
  |> should.equal(2)

  result2
  |> grid.rings()
  |> list.length()
  |> should.equal(3)

  result3
  |> grid.rings()
  |> list.length()
  |> should.equal(4)

  result4
  |> grid.rings()
  |> list.length()
  |> should.equal(5)
}
