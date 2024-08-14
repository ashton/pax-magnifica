import models/player.{type User}

pub type Session {
  Session(id: String, users: List(User))
}
