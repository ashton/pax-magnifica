import core/models/hex/grid.{type HexGrid}
import core/models/map.{type Tile}
import core/models/planetary_system.{type System}

// should be opaque but this would make testing it difficult
// so we handle it as an opaque type, even though it is not declared as one 
pub type MapCommand {
  CreateMapGrid(player_count: Int)
  SetTile(game: String, system: System, coordinates: #(Int, Int))
  CompleteMap(game: String, grid: HexGrid, tiles: List(Tile))
}

pub fn create_map_grid(player_count player_count: Int) {
  CreateMapGrid(player_count:)
}

pub fn set_tile(
  game game: String,
  system system: System,
  coordinates coords: #(Int, Int),
) {
  SetTile(game:, system: system, coordinates: coords)
}

pub fn complete(game game: String, grid grid: HexGrid, tiles tiles: List(Tile)) {
  CompleteMap(game:, grid:, tiles:)
}
