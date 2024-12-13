import engine/map/commands.{CreateMapGrid}
import glacier
import glacier/should

pub fn main() {
  glacier.main()
}

pub fn create_map_grid_test() {
  let assert CreateMapGrid(ring_amount) = commands.create_map_grid(3)
  ring_amount |> should.equal(3)
}
