import core/models/hex/grid
import engine/map/commands.{CompleteMap, CreateMapGrid, SetTile}
import game/systems

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
  let assert Ok(g) = grid.new(1)
  let expectation = CompleteMap("game_id", g, [])

  let subject = commands.complete("game_id", g, [])

  assert expectation == subject
}
