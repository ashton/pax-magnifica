import events/session.{user_joined}
import models/event.{type Event, NoSource, session_event}
import models/player.{type User}

pub type SessionCommand {
  Join(session_id: String, User)
}

pub fn handle_session_action(action: SessionCommand) -> Event {
  case action {
    Join(session_id, user) -> user_joined(session_id, user)
  }
  |> session_event(NoSource)
}
