import core/models/player.{type User}

// should be opaque but this would make testing it difficult
// so we handle it as an opaque type, even though it is not declared as one
pub type LobbyCommand {
  CreateLobby(id: String)
  JoinLobby(lobby: String, user: User)
}

pub fn create_lobby(id: String) -> LobbyCommand {
  CreateLobby(id)
}

pub fn join_lobby(lobby: String, user: User) -> LobbyCommand {
  JoinLobby(lobby, user)
}
