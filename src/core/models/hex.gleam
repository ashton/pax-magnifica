import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}

pub opaque type Coord {
  Coord(x: Int, y: Int)
}

pub opaque type HexGridRing {
  HexGridRing(ring_number: Int, coordinates: List(Coord))
}

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

pub fn coord(x: Int, y: Int) {
  Coord(x:, y:)
}

pub fn coord_from_pair(pair: #(Int, Int)) {
  let #(x, y) = pair

  Coord(x:, y:)
}

pub fn coord_to_pair(coord: Coord) -> #(Int, Int) {
  let Coord(x:, y:) = coord

  #(x, y)
}

fn build_grid(ring_amount: Int) -> HexGrid {
  [center_pairs]
  |> list.append([first_ring_pairs])
  |> list.append([second_ring_pairs])
  |> list.append([third_ring_pairs])
  |> list.append([fourth_ring_pairs])
  |> list.take(ring_amount + 1)
  |> list.index_map(with: fn(coords, index) {
    HexGridRing(
      ring_number: index,
      coordinates: coords |> list.map(coord_from_pair),
    )
  })
  |> HexGrid
}

pub fn new_grid(ring_amount: Int) -> Result(HexGrid, String) {
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
    let HexGridRing(ring_number:, coordinates:) = ring

    acc
    |> dict.insert(
      for: ring_number,
      insert: coordinates |> list.map(coord_to_pair),
    )
  })
}

pub fn ring(grid: HexGrid, number: Int) -> Option(HexGridRing) {
  let HexGrid(grid_rings) = grid
  grid_rings
  |> list.find(fn(ring: HexGridRing) {
    let HexGridRing(ring_number:, ..) = ring

    ring_number == number
  })
  |> option.from_result()
}

pub fn new_ring(number: Int, coordinates: List(Coord)) -> HexGridRing {
  HexGridRing(ring_number: number, coordinates:)
}

pub fn ring_number(ring: HexGridRing) -> Int {
  let HexGridRing(ring_number:, ..) = ring

  ring_number
}

pub fn ring_coordinates(ring: HexGridRing) -> List(Coord) {
  let HexGridRing(coordinates:, ..) = ring

  coordinates
}
