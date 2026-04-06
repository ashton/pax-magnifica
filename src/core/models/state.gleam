import core/models/player.{type Player, type User}
import core/models/state/game.{type GameState}
import core/models/state/map.{type MapState}
import core/models/state/player.{type PlayerSetupState} as _
import gleam/dict.{type Dict}

pub type State {
  Initial
  Lobby(state: List(User))
  PlayerSetup(state: Dict(String, PlayerSetupState))
  MapSetup(state: MapState)
  Active(state: GameState)
  Ended(winner: Player)
}

pub fn update_lobby(
  state: State,
  updater: fn(List(User)) -> List(User),
) -> State {
  case state {
    Lobby(users) -> Lobby(updater(users))
    _ -> panic as "State should be Lobby to run update_lobby"
  }
}

pub fn update_map(state: State, updater: fn(MapState) -> MapState) -> State {
  case state {
    MapSetup(map) -> MapSetup(updater(map))
    _ -> panic as "State should be a MapSetup to run update_map"
  }
}
