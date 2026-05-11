import core/models/hex/grid
import core/models/hex/hex
import core/models/map.{Drafting} as game_map
import core/models/state.{Initial, MapSetup}
import core/models/state/map.{MapState}
import engine/map/event_handler
import engine/map/events
import game/systems
import gleam/dict
import unitest

pub fn apply_grid_defined_transitions_to_map_setup_test() {
  use <- unitest.tags(["unit", "map", "event_handler"])
  let assert Ok(g) = grid.new(3)
  let event = events.grid_defined("game_1", g)

  let assert MapSetup(state: map_state) = event_handler.apply(Initial, event)

  assert "game_1" == map_state.id
  assert Drafting(dict.new()) == map_state.map
}

pub fn apply_tile_set_adds_tile_to_drafting_map_test() {
  use <- unitest.tags(["unit", "map", "event_handler"])
  let assert Ok(h) = hex.new(0, 0)
  let initial = MapSetup(MapState(id: "game_1", map: game_map.default()))
  let event = events.tile_set("game_1", systems.mecatol_rex_system, h)

  let assert MapSetup(state: map_state) = event_handler.apply(initial, event)

  assert Drafting(dict.from_list([#(h, systems.mecatol_rex_system)])) == map_state.map
}

pub fn apply_map_created_replaces_map_test() {
  use <- unitest.tags(["unit", "map", "event_handler"])
  let assert Ok(h) = hex.new(0, 0)
  let tiles = dict.from_list([#(h, systems.mecatol_rex_system)])
  let completed_map = game_map.new(tiles)
  let initial = MapSetup(MapState(id: "game_1", map: game_map.default()))
  let event = events.map_created("game_1", map: completed_map)

  let assert MapSetup(state: map_state) = event_handler.apply(initial, event)

  assert completed_map == map_state.map
}
