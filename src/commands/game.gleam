import events/game.{type GameEvent, GameCreated, GameStarted}

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

pub fn handle_game_command(command: GameCommand) -> GameEvent {
  case command {
    InitGame(id) -> GameCreated(id:)
    StartGame(id) -> GameStarted(id:)
  }
}
