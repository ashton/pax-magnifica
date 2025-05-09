import core/models/hex/grid
import core/models/hex/hex
import core/models/map
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

pub fn process_complete_command_test() {
  let hexgrid =
    grid.new(0)
    |> should.be_ok()

  let hextile =
    hex.new(0, 0)
    |> should.be_ok()

  let tile = map.Tile(system: systems.mecatol_rex_system, hex: hextile)

  let map = map.new([tile], hexgrid)

  let command = commands.complete("game_id", grid: hexgrid, tiles: [tile])
  let event = events.map_created("game_id", map:)

  process(command)
  |> list.first()
  |> should.be_ok()
  |> should.equal(event)
}
