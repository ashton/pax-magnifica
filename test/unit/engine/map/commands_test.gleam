import engine/map/commands.{CreateMapGrid, SetTile}
import game/systems
import glacier/should

pub fn create_map_grid_test() {
  let assert CreateMapGrid(ring_amount) = commands.create_map_grid(3)
  ring_amount |> should.equal(3)
}

pub fn set_tile_test() {
  let expectation = SetTile("map_id", systems.mecatol_rex_system, #(0, 0))

  commands.set_tile("map_id", systems.mecatol_rex_system, #(0, 0))
  |> should.equal(expectation)
}
