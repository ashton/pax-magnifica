import core/models/hex/grid
import core/models/hex/hex
import core/models/map
import engine/map/events
import game/systems
import gleam/dict
import gleam/result
import unitest

pub fn grid_defined_test() {
  use <- unitest.tags(["unit", "map", "events"])
  use g <- result.map(grid.new(3))
  let expectation = events.GridDefined("id", g)
  assert expectation == events.grid_defined("id", g)
}

pub fn tile_set_test() {
  use <- unitest.tags(["unit", "map", "events"])
  let map_id = "map_id"
  let system = systems.mecatol_rex_system
  let assert Ok(h) = hex.new(0, 0)
  let expectation = events.TileSet(map_id, system, h)

  assert expectation == events.tile_set(map_id, system, h)
}

pub fn map_completed_test() {
  use <- unitest.tags(["unit", "map", "events"])
  let assert Ok(h) = hex.new(0, 0)
  let tiles = dict.from_list([#(h, systems.mecatol_rex_system)])
  let map = map.new(tiles)
  let expectation = events.MapCreated("game_id", map:)

  assert expectation == events.map_created("game_id", map:)
}
