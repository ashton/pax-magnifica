import events/game.{GameCreated, GameStarted}
import models/event.{type Event, NoSource, game_event}
import models/map.{type Map}
import models/player.{type Player}

pub opaque type GameCommand {
  InitGame(id: String)
  StartGame(id: String)
}

pub fn init_game(id: String) {
  InitGame(id)
}

pub fn start_game(id: String) {
  StartGame(id:)
}

pub fn handle_game_command(command: GameCommand) -> Event {
  case command {
    InitGame(id) -> GameCreated(id:)
    StartGame(id) -> GameStarted(id:)
  }
  |> game_event(NoSource)
}
