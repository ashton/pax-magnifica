import core/models/player.{User}
import engine/commands/player as commands
import engine/events/player as events

pub fn handle_init_game_test() {
  let user = User(name: "test")
  let cmd =
    commands.join_lobby(user)
    |> commands.handle_player_command()

  assert cmd == events.UserJoined(user)
}
