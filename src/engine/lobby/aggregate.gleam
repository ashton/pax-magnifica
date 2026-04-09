import engine/lobby/commands.{type LobbyCommand, CreateLobby, JoinLobby}
import gleam/string

pub fn validate_command(command: LobbyCommand) -> Result(LobbyCommand, String) {
  case command {
    CreateLobby(id) ->
      case string.is_empty(id) {
        True -> Error("Lobby id cannot be empty")
        False -> Ok(command)
      }
    JoinLobby(_, _) -> Ok(command)
  }
}
