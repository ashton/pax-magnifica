import events/player.{type PlayerEvent, UserJoined} as _
import models/player.{type User}

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
