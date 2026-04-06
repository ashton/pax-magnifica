import core/models/hex/grid
import core/models/hex/hex
import core/models/map
import engine/map/events
import game/systems
import gleam/result

pub fn grid_defined_test() {
  use grid <- result.map(grid.new(3))
  let expectation = events.GridDefined("id", grid)
  assert expectation == events.grid_defined("id", grid)
}

pub fn tile_set_test() {
  let map_id = "map_id"
  let system = systems.mecatol_rex_system
  let coordinates = #(0, 0)
  let expectation = events.TileSet(map_id, system, coordinates)

  assert expectation == events.tile_set(map_id, system, coordinates)
}

pub fn map_completed_test() {
  let assert Ok(hexgrid) = grid.new(0)
  let assert Ok(hextile) = hex.new(0, 0)

  let tile = map.Tile(system: systems.mecatol_rex_system, hex: hextile)
  let map = map.new([tile], hexgrid)

  let expectation = events.MapCreated("game_id", map:)

  assert expectation == events.map_created("game_id", map:)
}
