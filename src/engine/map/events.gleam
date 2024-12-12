import core/models/hex/coordinate.{type Coordinate}
import core/models/hex/grid.{type HexGrid}
import core/models/planetary_system.{type System}

pub type MapEvent {
  MapCreated(id: String, grid: HexGrid)
  TileSet(map: String, system: System, coordinates: Coordinate)
}

pub fn map_created(id: String, grid: HexGrid) {
  MapCreated(id:, grid:)
}
