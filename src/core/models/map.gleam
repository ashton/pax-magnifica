import core/models/hex/grid.{type HexGrid}
import core/models/hex/hex.{type Hex}
import core/models/planetary_system.{type System}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

pub type Tile {
  Tile(system: System, hex: Hex)
}

pub type Map {
  Drafting(tiles: List(Tile), grid: Option(HexGrid))
  Map(tiles: List(Tile), grid: HexGrid, active_system: Option(Tile))
}

pub fn setup(tiles: Option(List(Tile)), grid: Option(HexGrid)) {
  Drafting(tiles: tiles |> option.unwrap([]), grid:)
}

pub fn complete(map: Map) -> Result(Map, String) {
  case map {
    Drafting(tiles: tiles, grid: Some(grid)) -> {
      let map_tiles_amount = tiles |> list.length()
      let grid_hexes_amount =
        grid
        |> grid.hexes
        |> list.length

      case map_tiles_amount == grid_hexes_amount {
        True -> Map(tiles:, grid:, active_system: None)
        False -> map
      }
      |> Ok()
    }

    Drafting(grid: None, ..) -> map |> Ok

    _ -> Error("Map is already completed")
  }
}

pub fn default() {
  setup(None, None)
}

pub fn new(tiles: List(Tile), grid: HexGrid) {
  Map(tiles:, grid:, active_system: None)
}

pub fn add_tile(
  map: Result(Map, String),
  tile: Result(Tile, String),
) -> Result(Map, String) {
  map.map()
  case map {
    Drafting(tiles, _) -> Drafting(..map, tiles: list.append(tiles, [tile]))
    _ -> panic as "Only drafting maps can have its tiles changed"
  }
}

pub fn new_tile(
  system: System,
  hex_tile: Result(Hex, String),
) -> Result(Tile, String) {
  result.map(hex_tile, fn(hex) { Tile(system:, hex:) })
}
