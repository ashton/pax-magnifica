import core/models/game.{type Game}
import core/models/player.{type Player, type User}

pub type State {
  Initial
  LobbyPhase(users: List(User))
  PlayingPhase(game: Game)
  EndGamePhase(winner: Player)
}

pub fn map_game(state: State, updater: fn(Game) -> Game) -> State {
  case state {
    PlayingPhase(game: current_game) ->
      PlayingPhase(game: updater(current_game))
    _ -> panic as "Unable to update state: Not in playing phase"
  }
}
