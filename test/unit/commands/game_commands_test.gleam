import engine/commands/game as commands
import engine/events/game as events

pub fn handle_init_game_test() {
  let res =
    commands.init_game("test")
    |> commands.handle_game_command()

  assert res == events.GameCreated("test")
}

pub fn start_game_test() {
  let res =
    commands.start_game("test")
    |> commands.handle_game_command()

  assert res == events.GameStarted("test")
}
