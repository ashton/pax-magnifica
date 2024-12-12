import core/models/hex/coordinate.{type Coordinate}
import core/models/planetary_system.{type System}

pub type MapCommand {
  CreateMapGrid(ring_amount: Int)
  SetTile(map: String, system: System, coordinates: Coordinate)
}

pub fn create_map_grid(ring_amount: Int) {
  CreateMapGrid(ring_amount:)
}

pub fn set_tile(map: String, system: System, coords: Coordinate) {
  SetTile(map:, system: system, coordinates: coords)
}
