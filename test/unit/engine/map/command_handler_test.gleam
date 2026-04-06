import core/models/hex/grid
import core/models/hex/hex
import core/models/map
import engine/map/command_handler.{process}
import engine/map/commands
import engine/map/events.{GridDefined}
import game/systems
import gleam/bool
import gleam/list
import gleam/string

pub fn process_create_map_grid_command_test() {
  let command = commands.create_map_grid(3)

  let assert Ok(subject) = process(command) |> list.first()

  let assert GridDefined(id, grid) = subject
  assert id |> string.is_empty() |> bool.negate()
  assert 4 == grid |> grid.length()
}

pub fn process_set_tile_command_test() {
  let command = commands.set_tile("map_id", systems.mecatol_rex_system, #(0, 0))
  let event = events.tile_set("map_id", systems.mecatol_rex_system, #(0, 0))

  let assert Ok(subject) = process(command) |> list.first()

  assert event == subject
}

pub fn process_complete_command_test() {
  let assert Ok(hexgrid) = grid.new(0)
  let assert Ok(hextile) = hex.new(0, 0)

  let tile = map.Tile(system: systems.mecatol_rex_system, hex: hextile)

  let map = map.new([tile], hexgrid)

  let command = commands.complete("game_id", grid: hexgrid, tiles: [tile])
  let event = events.map_created("game_id", map:)

  let assert Ok(res) = process(command) |> list.first()
  assert event == res
}
