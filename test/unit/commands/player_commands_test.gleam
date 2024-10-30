import commands/player as commands
import events/player as events
import glacier
import glacier/should
import models/player.{User}

pub fn main() {
  glacier.main()
}

pub fn handle_init_game_test() {
  let user = User(name: "test")
  commands.join_lobby(user)
  |> commands.handle_player_command()
  |> should.equal(events.UserJoined(user))
}
