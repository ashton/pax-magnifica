import core/models/player.{User}
import engine/commands/player as commands
import engine/events/player as events
import glacier
import glacier/should

pub fn main() {
  glacier.main()
}

pub fn handle_init_game_test() {
  let user = User(name: "test")
  commands.join_lobby(user)
  |> commands.handle_player_command()
  |> should.equal(events.UserJoined(user))
}
