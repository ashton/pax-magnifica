import models/map.{type Map}
import models/player.{type Player}

pub type GameCreatedEvent {
  GameCreated(id: String, players: List(Player), map: Map)
}
