import core/models/player.{type User}

pub type LobbyEvent {
  LobbyCreated(id: String)
  UserJoined(id: String, user: User)
}
