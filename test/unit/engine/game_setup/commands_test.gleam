import core/models/game_setup.{Standard}
import engine/game_setup/aggregate
import engine/game_setup/commands.{CreateGame}
import glacier/should
import gleam/string

pub fn create_game_test() {
  let assert CreateGame(game_id, player_count, setup_type) =
    aggregate.create_game(6, Standard)
  game_id |> string.length() |> fn(length) { length > 0 } |> should.be_true()
  player_count |> should.equal(6)
  setup_type |> should.equal(Standard)
}
