import core/models/hex/hex
import core/models/hex/ring.{type HexGridRing}
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option}
import gleam/result

pub opaque type HexGrid {
  HexGrid(List(HexGridRing))
}

fn build_grid(radius: Int) -> Result(HexGrid, String) {
  list.range(0, radius)
  |> list.map(ring.create)
  |> result.all()
  |> result.map(HexGrid)
}

pub fn new(radius radius: Int) -> Result(HexGrid, String) {
  case radius {
    0 | 1 | 2 | 3 | 4 -> build_grid(radius)
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

pub fn to_dict(grid: HexGrid) -> Dict(#(Int, Int), hex.Hex) {
  let HexGrid(grid_rings) = grid

  grid_rings
  |> list.map(ring.items)
  |> list.flatten()
  |> list.fold(from: dict.new(), with: fn(acc, item) {
    dict.insert(acc, for: hex.to_pair(item), insert: item)
  })
}

pub fn ring(grid: HexGrid, number: Int) -> Option(HexGridRing) {
  let HexGrid(grid_rings) = grid
  grid_rings
  |> list.drop(number - 1)
  |> list.first()
  |> option.from_result
}
