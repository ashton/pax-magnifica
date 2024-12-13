import engine/map/aggregate
import engine/map/commands
import glacier
import glacier/should

pub fn main() {
  glacier.main()
}

pub fn validate_create_map_grid_with_valid_params_test() {
  let command = commands.create_map_grid(player_count: 6)

  aggregate.validate_command(command)
  |> should.be_ok()
  |> should.equal(command)
}

pub fn validate_create_map_grid_with_invalid_params_test() {
  let command = commands.create_map_grid(player_count: 2)

  aggregate.validate_command(command)
  |> should.be_error()
  |> should.equal(
    "Invalid player count: 2. A game should have 3 players minimum, and 6 players maximum.",
  )
}
