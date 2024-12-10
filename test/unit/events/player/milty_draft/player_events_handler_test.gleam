import core/models/player.{User}
import core/models/state
import draft/engine/draft
import draft/models/draft.{Milty} as _
import engine/events/player as events
import glacier
import glacier/should

pub fn main() {
  glacier.main()
}

pub fn build_draft_phase_state() {
  state.DraftPhase(draft: draft.setup(Milty, [User(name: "test")]))
  |> Ok
}

pub fn handle_user_joined_event_test() {
  events.UserJoined(User(name: "test"))
  |> events.event_handler(build_draft_phase_state())
  |> should.equal(Error(""))
}
