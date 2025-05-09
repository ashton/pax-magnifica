import core/models/game.{type Game}
import core/models/player.{type Player, type User}
import core/models/state/game.{type GameState}
import gleam/dict.{type Dict}

pub type PlayerState {
  PlayerState(id: String, player: Player)
}

pub type State {
  Initial
  Lobby(state: List(User))
  PlayerSetup(state: Dict(String, PlayerState))
  MapSetup(state: MapState)
  Active(state: GameState)
  Ended(winner: Player)
}
