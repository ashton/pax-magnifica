import core/models/map.{type Map}
import core/models/player.{type Player, type User}

pub type GameState {
  GameState(id: String, map: Map)
}

pub type State {
  Initial
  LobbyPhase(users: List(User))
  PlayingPhase(game: GameState)
  EndGamePhase(winner: Player)
}

pub fn update_playing_phase(
  state: State,
  game_updater: fn(GameState) -> GameState,
) -> State {
  case state {
    PlayingPhase(game: current_game) ->
      PlayingPhase(game: game_updater(current_game))
    _ -> panic as "Unable to update state: Not in playing phase"
  }
}

pub fn update_game_id(game_state: GameState, id_updater: fn(String) -> String) {
  let GameState(id: current_id, ..) = game_state

  GameState(..game_state, id: id_updater(current_id))
}

pub fn update_game_map(game_state: GameState, map_updater: fn(Map) -> Map) {
  let GameState(map: current_map, ..) = game_state

  GameState(..game_state, map: map_updater(current_map))
}
