import events/player.{UserJoined} as _
import models/event.{type Event, NoSource}
import models/player.{type User}

pub opaque type PlayerCommand {
  JoinLobby(user: User)
}

pub fn join_lobby(user: User) -> PlayerCommand {
  JoinLobby(user)
}

pub fn handle_player_action(action: PlayerCommand) -> Event {
  case action {
    JoinLobby(user) -> UserJoined(user) |> event.player_event(NoSource)
  }
}
