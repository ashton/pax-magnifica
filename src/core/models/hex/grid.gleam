import core/models/hex/hex.{type Hex}
import core/models/hex/ring
import gleam/int
import gleam/list
import gleam/result
import gleam/set.{type Set}

pub opaque type HexGrid {
  HexGrid(radius: Int, hexes: Set(Hex))
}

fn build_grid(radius: Int) -> Result(HexGrid, String) {
  int.range(from: 0, to: radius + 1, with: [], run: list.prepend)
  |> list.map(ring.create)
  |> result.all()
  |> result.map(fn(rings) {
    let hexes =
      rings
      |> list.flat_map(ring.items)
      |> set.from_list()
    HexGrid(radius:, hexes:)
  })
}

pub fn new(radius radius: Int) -> Result(HexGrid, String) {
  case radius {
    0 | 1 | 2 | 3 | 4 -> build_grid(radius)
    _ -> Error("Invalid amount of rings. It should be >= 0 and <= 4")
  }
}

pub fn radius(grid: HexGrid) -> Int {
  let HexGrid(radius:, ..) = grid
  radius
}

pub fn contains(grid: HexGrid, hex: Hex) -> Bool {
  let HexGrid(hexes:, ..) = grid
  set.contains(hexes, hex)
}

pub fn hexes(grid: HexGrid) -> List(Hex) {
  let HexGrid(hexes:, ..) = grid
  set.to_list(hexes)
}

pub fn hexes_by_ring(grid: HexGrid) -> List(Hex) {
  let HexGrid(radius:, ..) = grid
  int.range(from: 0, to: radius + 1, with: [], run: list.prepend)
  |> list.reverse()
  |> list.flat_map(fn(r) {
    case ring.create(r) {
      Ok(r) -> ring.items(r)
      Error(_) -> []
    }
  })
}
