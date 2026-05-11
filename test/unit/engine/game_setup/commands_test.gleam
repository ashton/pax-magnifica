import core/models/game_setup.{Standard}
import engine/game_setup/commands.{CreateGame}
import gleam/string
import unitest

pub fn create_game_test() {
  use <- unitest.tags(["unit", "game_setup", "commands"])
  let assert CreateGame(game_id, player_count, setup_type) =
    commands.create_game(6, Standard)

  assert game_id |> string.length() > 0
  assert 6 == player_count
  assert Standard == setup_type
}
