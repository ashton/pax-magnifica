import core/models/player.{type User}
import engine/lobby/events.{type LobbyEvent, LobbyCreated, UserJoined}

pub opaque type LobbyCommand {
  CreateLobby(id: String)
  JoinLobby(lobby: String, user: User)
}

pub fn create_lobby(id: String) {
  CreateLobby(id)
}

pub fn join_lobby(lobby: String, user: User) -> LobbyCommand {
  JoinLobby(lobby, user)
}

pub fn handle_command(command: LobbyCommand) -> LobbyEvent {
  case command {
    CreateLobby(id) -> LobbyCreated(id)
    JoinLobby(lobby, user) -> UserJoined(lobby, user)
  }
}
