import models/planetary_system.{type System}

pub type Tile {
  Tile(system: System, col: Int, row: Int)
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
