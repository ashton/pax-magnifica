import events/player as events
import game/draft
import glacier
import glacier/should
import models/draft.{Milty} as _
import models/player.{User}
import models/state

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
  |> should.equal()
}
