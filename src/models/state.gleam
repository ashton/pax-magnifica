import models/game.{type Game}
import models/map.{type Map}
import models/player.{type Player, type User}

pub type State {
  Initial
  LobbyPhase(users: List(User))
  DraftPhase(players: List(Player), map: Map)
  PlayingPhase(game: Game)
  EndGamePhase(winner: Player)
}

pub fn map_initial_phase(
  state: Result(State, String),
  mapper: fn() -> Result(State, String),
) {
  case state {
    Ok(Initial) -> mapper()
    _ -> state
  }
}

pub fn map_lobby_phase(
  state: Result(State, String),
  mapper: fn(List(User)) -> Result(State, String),
) {
  case state {
    Ok(LobbyPhase(users)) -> mapper(users)
    _ -> state
  }
}

pub fn map_draft_phase(
  state: Result(State, String),
  mapper: fn(List(Player), Map) -> Result(State, String),
) {
  case state {
    Ok(DraftPhase(players, map)) -> mapper(players, map)
    _ -> state
  }
}

pub fn map_playing_phase(
  state: Result(State, String),
  mapper: fn(Game) -> Result(State, String),
) {
  case state {
    Ok(PlayingPhase(game)) -> mapper(game)
    _ -> state
  }
}

pub fn map_end_game_phase(
  state: Result(State, String),
  mapper: fn(Player) -> Result(State, String),
) {
  case state {
    Ok(EndGamePhase(winner)) -> mapper(winner)
    _ -> state
  }
}
