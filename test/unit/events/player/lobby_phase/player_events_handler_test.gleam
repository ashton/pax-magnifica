import core/models/player.{User}
import core/models/state
import engine/events/player as events
import glacier/should

pub fn build_lobby_phase_state() {
  state.LobbyPhase(users: []) |> Ok
}

pub fn handle_user_joined_event_test() {
  events.UserJoined(User(name: "test"))
  |> events.event_handler(build_lobby_phase_state())
  |> should.be_ok()
  |> should.equal(state.LobbyPhase(users: [User(name: "test")]))
}
