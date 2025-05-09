import core/models/player.{type User}
import engine/events/player.{type PlayerEvent, UserJoined} as _

pub opaque type LobbyCommand {
  CreateLobby
  JoinLobby(user: User)
}

pub fn join_lobby(user: User) -> LobbyCommand {
  JoinLobby(user)
}

pub fn handle_player_command(command: LobbyCommand) -> PlayerEvent {
  case command {
    JoinLobby(user) -> UserJoined(user)
  }
}
