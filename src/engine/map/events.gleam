import core/models/hex/grid.{type HexGrid}
import core/models/map.{type Map}
import core/models/planetary_system.{type System}

pub type MapEvent {
  GridDefined(game: String, grid: HexGrid)
  MapCreated(game: String, map: Map)
  TileSet(game: String, system: System, coordinates: #(Int, Int))
}

pub fn grid_defined(game: String, grid: grid.HexGrid) {
  GridDefined(game:, grid:)
}

pub fn tile_set(game: String, system: System, coordinates: #(Int, Int)) {
  TileSet(game:, system:, coordinates:)
}

pub fn map_created(game: String, map: Map) {
  MapCreated(game:, map:)
}
