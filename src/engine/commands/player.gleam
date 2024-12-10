import core/models/player.{type User}
import engine/events/player.{type PlayerEvent, UserJoined} as _

pub opaque type PlayerCommand {
  JoinLobby(user: User)
}

pub fn join_lobby(user: User) -> PlayerCommand {
  JoinLobby(user)
}

pub fn handle_player_command(command: PlayerCommand) -> PlayerEvent {
  case command {
    JoinLobby(user) -> UserJoined(user)
  }
}
