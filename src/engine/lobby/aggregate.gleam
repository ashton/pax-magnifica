import core/value_objects/game
import engine/lobby/commands.{type LobbyCommand, CreateLobby, JoinLobby}
import gleam/result

pub fn validate_command(command: LobbyCommand) -> Result(LobbyCommand, String) {
  case command {
    CreateLobby(id) ->
      game.new_id(id)
      |> result.replace(command)
    JoinLobby(_, _) -> Ok(command)
  }
}
