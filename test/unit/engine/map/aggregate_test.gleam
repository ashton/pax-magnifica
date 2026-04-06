import engine/map/aggregate
import engine/map/commands

pub fn validate_create_map_grid_with_valid_params_test() {
  let command = commands.create_map_grid(player_count: 6)

  let assert Ok(res) = aggregate.validate_command(command)
  assert res == command
}

pub fn validate_create_map_grid_with_invalid_params_test() {
  let command = commands.create_map_grid(player_count: 2)

  let assert Error(err) = aggregate.validate_command(command)
  assert "Invalid player count: 2. A game should have 3 players minimum, and 6 players maximum."
    == err
}
