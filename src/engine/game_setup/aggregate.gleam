import engine/game_setup/commands.{
  type GameSetupCommand, AddSecretObjectiveToPlayer, AppointSpeaker, CreateGame,
  DealSecretObjectives, JoinGame, SetPlayerInitialComponents, StartGame,
}
import gleam/int
import gleam/result
import gleam/string

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

pub fn validate_command(
  command: GameSetupCommand,
) -> Result(GameSetupCommand, String) {
  case command {
    CreateGame(game_id, player_count, _) ->
      case string.is_empty(game_id) {
        True -> Error("Game id cannot be empty")
        False ->
          validate_player_count(player_count)
          |> result.replace(command)
      }

    JoinGame(game_id, player_id, _, _) ->
      case string.is_empty(game_id) || string.is_empty(player_id) {
        True -> Error("Game id and player id cannot be empty")
        False -> Ok(command)
      }

    AddSecretObjectiveToPlayer(game_id, player_id, _) ->
      case string.is_empty(game_id) || string.is_empty(player_id) {
        True -> Error("Game id and player id cannot be empty")
        False -> Ok(command)
      }

    DealSecretObjectives(game_id, player_id, _) ->
      case string.is_empty(game_id) || string.is_empty(player_id) {
        True -> Error("Game id and player id cannot be empty")
        False -> Ok(command)
      }

    AppointSpeaker(game_id, player_id) ->
      case string.is_empty(game_id) || string.is_empty(player_id) {
        True -> Error("Game id and player id cannot be empty")
        False -> Ok(command)
      }

    SetPlayerInitialComponents(game_id, player_id, _, _, _, _) ->
      case string.is_empty(game_id) || string.is_empty(player_id) {
        True -> Error("Game id and player id cannot be empty")
        False -> Ok(command)
      }

    StartGame -> Ok(command)
  }
}
