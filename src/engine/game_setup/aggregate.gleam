import core/value_objects/game
import core/value_objects/player
import engine/game_setup/commands.{
  type GameSetupCommand, AddSecretObjectiveToPlayer, AppointSpeaker, CreateGame,
  DealSecretObjectives, JoinGame, SetPlayerInitialComponents, StartGame,
}
import gleam/int
import gleam/result

fn validate_player_count(player_count: Int) -> Result(Int, String) {
  case player_count >= 3, player_count <= 6 {
    True, True -> Ok(player_count)
    _, _ ->
      Error(
        "Invalid player count: "
        <> int.to_string(player_count)
        <> ". A game should have 3 players minimum and 6 players maximum.",
      )
  }
}

fn validate_ids(game_id: String, player_id: String) -> Result(Nil, String) {
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  Ok(Nil)
}

pub fn validate_command(
  command: GameSetupCommand,
) -> Result(GameSetupCommand, String) {
  case command {
    CreateGame(game_id, player_count, _) ->
      game.new_id(game_id)
      |> result.try(fn(_) { validate_player_count(player_count) })
      |> result.replace(command)

    JoinGame(game_id, player_id, _, _) ->
      validate_ids(game_id, player_id)
      |> result.replace(command)

    AddSecretObjectiveToPlayer(game_id, player_id, _) ->
      validate_ids(game_id, player_id)
      |> result.replace(command)

    DealSecretObjectives(game_id, player_id, _) ->
      validate_ids(game_id, player_id)
      |> result.replace(command)

    AppointSpeaker(game_id, player_id) ->
      validate_ids(game_id, player_id)
      |> result.replace(command)

    SetPlayerInitialComponents(game_id, player_id, _, _, _, _) ->
      validate_ids(game_id, player_id)
      |> result.replace(command)

    StartGame -> Ok(command)
  }
}
