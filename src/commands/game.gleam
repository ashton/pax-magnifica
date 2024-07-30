import models/map.{type Map}
import models/player.{type Player}

pub type CreateGameCommand {
  CreateGame(players: List(Player), map: Map)
}
