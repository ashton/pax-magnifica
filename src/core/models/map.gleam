import core/models/hex/coordinate.{type Coordinate}
import core/models/hex/grid.{type HexGrid}
import core/models/planetary_system.{type System}
import gleam/option.{type Option, None}

pub type Tile {
  Tile(system: System, coordinates: Coordinate)
}

pub type Map {
  Drafting(tiles: List(Tile), grid: Option(HexGrid))
  Map(List(Tile))
}

pub fn new_drafting(tiles: Option(List(Tile)), grid: Option(HexGrid)) {
  Drafting(tiles: tiles |> option.unwrap([]), grid:)
}

pub fn update_drafting_tiles(
  map: Map,
  tiles_updater: fn(List(Tile)) -> List(Tile),
) -> Map {
  case map {
    Drafting(tiles:, ..) as prev ->
      Drafting(..prev, tiles: tiles_updater(tiles))
    _ ->
      panic as "Impossible to update drafting tiles, Map is not in drafting state."
  }
}

pub fn update_drafting_grid(
  map: Map,
  grid_updater: fn(Option(HexGrid)) -> Option(HexGrid),
) {
  case map {
    Drafting(grid:, ..) as prev -> Drafting(..prev, grid: grid_updater(grid))
    _ ->
      panic as "Impossible to update drafting grid, Map is not in drafting state."
  }
}

pub fn update_map_tiles(
  map: Map,
  tiles_updater: fn(List(Tile)) -> List(Tile),
) -> Map {
  case map {
    Map(tiles) -> Map(tiles_updater(tiles))
    _ -> panic as "Impossible to update map tiles, Map id not complete."
  }
}

pub fn default() {
  new_drafting(None, None)
}

pub fn new(tiles: List(Tile)) {
  Map(tiles)
}
