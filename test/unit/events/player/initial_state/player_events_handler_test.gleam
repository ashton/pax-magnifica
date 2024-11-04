import events/player as events
import glacier
import glacier/should
import models/player.{User}
import models/state

pub fn main() {
  glacier.main()
}

pub fn build_initial_state() {
  state.Initial |> Ok
}

pub fn handle_user_joined_event_test() {
  events.UserJoined(User(name: "test"))
  |> events.event_handler(build_initial_state())
  |> should.be_error()
  |> should.equal("Create a game first!")
}
