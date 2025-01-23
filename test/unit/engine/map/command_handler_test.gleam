import core/models/hex/grid
import engine/map/command_handler.{process}
import engine/map/commands
import engine/map/events.{GridDefined}
import game/systems
import glacier/should
import gleam/list
import gleam/string

pub fn process_create_map_grid_command_test() {
  let command = commands.create_map_grid(3)

  process(command)
  |> list.first()
  |> should.be_ok()
  |> fn(event) {
    let assert GridDefined(id, grid) = event
    id |> string.is_empty() |> should.be_false()
    grid |> grid.length() |> should.equal(4)
  }
}

pub fn process_set_tile_command_test() {
  let command = commands.set_tile("map_id", systems.mecatol_rex_system, #(0, 0))
  let event = events.tile_set("map_id", systems.mecatol_rex_system, #(0, 0))

  process(command)
  |> list.first()
  |> should.be_ok()
  |> should.equal(event)
}
