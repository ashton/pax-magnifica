import core/models/game.{type Game}
import core/models/player.{type Player, type User}

pub type State {
  Initial
  LobbyPhase(users: List(User))
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
