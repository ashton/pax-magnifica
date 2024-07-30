import models/planetary_system.{type System}

pub type Tile {
  Tile(id: Int, system: System)
}

pub type Map {
  Map(List(Tile))
}
