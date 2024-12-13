import core/models/hex/coordinate
import core/models/hex/grid
import engine/map/events
import game/systems
import glacier
import glacier/should
import gleam/result

pub fn main() {
  glacier.main()
}

pub fn grid_defined_test() {
  use grid <- result.map(grid.new(3))
  let expectation = events.GridDefined("id", grid)
  events.grid_defined("id", grid)
  |> should.equal(expectation)
}

pub fn tile_set_test() {
  let map_id = "map_id"
  let system = systems.mecatol_rex_system
  let coordinates = coordinate.new(0, 0)
  let expectation = events.TileSet(map_id, system, coordinates)

  events.tile_set(map_id, system, coordinates)
  |> should.equal(expectation)
}
