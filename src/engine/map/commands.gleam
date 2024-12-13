import core/models/hex/coordinate.{type Coordinate}
import core/models/planetary_system.{type System}

pub type MapCommand {
  CreateMapGrid(player_count: Int)
  SetTile(game: String, system: System, coordinates: Coordinate)
}

pub fn create_map_grid(player_count player_count: Int) {
  CreateMapGrid(player_count:)
}

pub fn set_tile(game: String, system: System, coords: Coordinate) {
  SetTile(game:, system: system, coordinates: coords)
}
