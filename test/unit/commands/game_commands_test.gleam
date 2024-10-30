import commands/game as commands
import events/game as events
import glacier
import glacier/should

pub fn main() {
  glacier.main()
}

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
