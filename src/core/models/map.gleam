import core/models/hex/coordinate.{type Coordinate}
import core/models/planetary_system.{type System}

pub type Tile {
  Tile(system: System, coordinates: Coordinate)
}

pub opaque type Map {
  Map(List(Tile))
}

pub fn default() {
  Map([])
}

pub fn init(tiles: List(Tile)) {
  Map(tiles)
}
