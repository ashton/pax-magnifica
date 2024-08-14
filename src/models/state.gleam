import models/game.{type Game}
import models/map.{type Map}
import models/player.{type Player}
import models/session.{type Session}

pub type State {
  Initial
  LobbyPhase(session: Session)
  DraftPhase(players: List(Player), map: Map)
  PlayingPhase(game: Game)
  EndGamePhase(winner: Player)
}
