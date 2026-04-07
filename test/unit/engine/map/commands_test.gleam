import core/models/hex/hex
import core/models/planetary_system
import engine/map/commands.{CompleteMap, CreateMapGrid, SetTile}
import game/systems
import gleam/dict

pub fn create_map_grid_test() {
  let assert CreateMapGrid(ring_amount) = commands.create_map_grid(3)
  assert 3 == ring_amount
}

pub fn set_tile_test() {
  let expectation = SetTile("map_id", systems.mecatol_rex_system, #(0, 0))
  let subject = commands.set_tile("map_id", systems.mecatol_rex_system, #(0, 0))

  assert expectation == subject
}

pub fn complete_map_test() {
  let assert Ok(h) = hex.new(0, 0)
  let tiles = dict.from_list([#(h, systems.mecatol_rex_system)])
  let expectation = CompleteMap("game_id", tiles)

  let subject = commands.complete("game_id", tiles)

  assert expectation == subject
}
