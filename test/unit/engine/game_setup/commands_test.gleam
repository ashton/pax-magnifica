import core/models/game_setup.{Standard}
import engine/game_setup/commands.{CreateGame}
import gleam/string

pub fn create_game_test() {
  let assert CreateGame(game_id, player_count, setup_type) =
    commands.create_game(6, Standard)

  assert game_id |> string.length() > 0
  assert 6 == player_count
  assert Standard == setup_type
}
