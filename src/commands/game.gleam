import events/game as game_events
import models/event.{type Event, NoSource, game_event}
import models/map.{type Map}
import models/player.{type Player}

pub type GameCommand {
  CreateGame
  SetGameMap(game_id: String, map: Map)
  AddPlayerToGame(game_id: String, player: Player)
}

pub fn handle_game_action(action: GameCommand) -> Event {
  case action {
    CreateGame -> {
      game_events.game_created()
    }
    AddPlayerToGame(game_id, player) -> todo
    SetGameMap(game_id, map) -> todo
  }
  |> game_event(NoSource)
}
