import engine/commands/game as commands
import engine/events/game as events
import glacier/should

pub fn handle_init_game_test() {
  commands.init_game("test")
  |> commands.handle_game_command()
  |> should.equal(events.GameCreated("test"))
}

pub fn start_game_test() {
  commands.start_game("test")
  |> commands.handle_game_command()
  |> should.equal(events.GameStarted("test"))
}
