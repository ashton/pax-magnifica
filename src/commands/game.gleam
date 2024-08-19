import events/game.{GameCreated}
import models/event.{type Event, NoSource, game_event}
import models/map.{type Map}
import models/player.{type Player}

pub opaque type GameCommand {
  InitGame(id: String)
  SetGameMap(map: Map)
  AddPlayerToGame(player: Player)
}

pub fn init_game(id: String) {
  InitGame(id)
}

pub fn handle_game_command(command: GameCommand) -> Event {
  case command {
    InitGame(id) -> GameCreated(id:)
    AddPlayerToGame(player) -> todo
    SetGameMap(map) -> todo
  }
  |> game_event(NoSource)
}
