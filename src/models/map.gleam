import models/planetary_system.{type System}

pub type Tile {
  Tile(id: Int, system: System)
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
