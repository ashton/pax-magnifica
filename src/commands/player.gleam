import events/player.{UserJoined} as _
import models/event.{type Event, NoSource}
import models/player.{type User}

pub opaque type PlayerCommand {
  JoinLobby(user: User)
}

pub fn join_lobby(user: User) -> PlayerCommand {
  JoinLobby(user)
}

pub fn handle_player_command(command: PlayerCommand) -> Event {
  case command {
    JoinLobby(user) -> UserJoined(user) |> event.player_event(NoSource)
  }
}
