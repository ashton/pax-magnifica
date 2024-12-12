import core/models/hex/coordinate
import core/models/hex/ring.{type HexGridRing}
import gleam/dict
import gleam/list
import gleam/option.{type Option}

pub opaque type HexGrid {
  HexGrid(List(HexGridRing))
}

const center_pairs = [#(0, 0)]

const first_ring_pairs = [
  #(0, -1), #(1, -1), #(1, 0), #(0, 1), #(-1, 1), #(-1, 0),
]

const second_ring_pairs = [
  #(0, -2), #(1, -2), #(2, -2), #(2, -1), #(2, 0), #(1, 1), #(0, 2), #(-1, 2),
  #(-2, 2), #(-2, 1), #(-2, 0), #(-1, -1),
]

const third_ring_pairs = [
  #(0, -3), #(1, -3), #(2, -3), #(3, -3), #(3, -2), #(3, -1), #(3, 0), #(2, 1),
  #(1, 2), #(0, 3), #(-1, 3), #(-2, 3), #(-3, 3), #(-3, 2), #(-3, 1), #(-3, 0),
  #(-2, -1), #(-1, -2),
]

const fourth_ring_pairs = [
  #(0, -4), #(1, -4), #(2, -4), #(3, -4), #(4, -4), #(4, -3), #(4, -2), #(4, -1),
  #(4, 0), #(3, 1), #(2, 2), #(1, 3), #(0, 4), #(-1, 4), #(-2, 4), #(-3, 4),
  #(-4, 4), #(-4, 3), #(-4, 2), #(-4, 1), #(-4, 0), #(-3, -1), #(-2, -2),
  #(-1, -3),
]

fn build_grid(ring_amount: Int) -> HexGrid {
  [center_pairs]
  |> list.append([first_ring_pairs])
  |> list.append([second_ring_pairs])
  |> list.append([third_ring_pairs])
  |> list.append([fourth_ring_pairs])
  |> list.take(ring_amount + 1)
  |> list.index_map(with: fn(coords, index) {
    ring.new(
      number: index,
      coordinates: coords |> list.map(coordinate.from_pair),
    )
  })
  |> HexGrid
}

pub fn new(ring_amount: Int) -> Result(HexGrid, String) {
  case ring_amount {
    0 | 1 | 2 | 3 | 4 -> build_grid(ring_amount) |> Ok
    _ -> Error("Invalid amount of rings. It should be >= 0 and <= 4")
  }
}

pub fn length(grid: HexGrid) -> Int {
  let HexGrid(rings) = grid

  list.length(rings)
}

pub fn rings(grid: HexGrid) -> List(HexGridRing) {
  let HexGrid(grid_rings) = grid

  grid_rings
}

pub fn to_dict(grid: HexGrid) {
  grid
  |> rings()
  |> list.fold(from: dict.new(), with: fn(acc, ring) {
    let ring_number = ring |> ring.number()
    let coordinates = ring |> ring.coordinates()

    acc
    |> dict.insert(
      for: ring_number,
      insert: coordinates |> list.map(coordinate.to_pair),
    )
  })
}

pub fn ring(grid: HexGrid, number: Int) -> Option(HexGridRing) {
  let HexGrid(grid_rings) = grid
  grid_rings
  |> list.find(fn(ring: HexGridRing) {
    let ring_number = ring |> ring.number()
    ring_number == number
  })
  |> option.from_result()
}
