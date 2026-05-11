import core/models/hex/grid
import core/models/hex/hex
import core/models/map
import engine/map/aggregate
import engine/map/commands
import engine/map/events.{GridDefined}
import game/systems
import gleam/bool
import gleam/dict
import gleam/list
import gleam/string
import unitest

pub fn handle_create_map_grid_valid_test() {
  use <- unitest.tags(["unit", "map", "aggregate"])
  let command = commands.create_map_grid(player_count: 3)
  let assert Ok(_) = aggregate.handle(command)
}

pub fn handle_create_map_grid_invalid_player_count_returns_error_test() {
  use <- unitest.tags(["unit", "map", "aggregate"])
  let command = commands.create_map_grid(player_count: 2)
  let assert Error(err) = aggregate.handle(command)
  assert "Invalid player count: 2. A game should have 3 players minimum, and 6 players maximum."
    == err
}

pub fn handle_create_map_grid_emits_grid_defined_test() {
  use <- unitest.tags(["unit", "map", "aggregate"])
  let command = commands.create_map_grid(3)
  let assert Ok(events) = aggregate.handle(command)
  let assert Ok(GridDefined(id, g)) = list.first(events)
  assert id |> string.is_empty() |> bool.negate()
  assert 3 == grid.radius(g)
}

pub fn handle_set_tile_emits_tile_set_test() {
  use <- unitest.tags(["unit", "map", "aggregate"])
  let assert Ok(h) = hex.new(0, 0)
  let command = commands.set_tile("map_id", systems.mecatol_rex_system, h)
  let expected = events.tile_set("map_id", systems.mecatol_rex_system, h)
  let assert Ok(events) = aggregate.handle(command)
  let assert Ok(event) = list.first(events)
  assert event == expected
}

pub fn handle_complete_map_emits_map_created_test() {
  use <- unitest.tags(["unit", "map", "aggregate"])
  let assert Ok(h) = hex.new(0, 0)
  let tiles = dict.from_list([#(h, systems.mecatol_rex_system)])
  let expected = events.map_created("game_id", map.new(tiles))
  let command = commands.complete("game_id", tiles:)
  let assert Ok(events) = aggregate.handle(command)
  let assert Ok(event) = list.first(events)
  assert event == expected
}
