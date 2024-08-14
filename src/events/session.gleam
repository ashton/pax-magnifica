import gleam/list
import gleam/result
import models/player.{type User}
import models/session.{Session}
import models/state.{type State, Initial, LobbyPhase}

pub opaque type SessionEvent {
  UserJoined(session_id: String, user: User)
}

pub fn user_joined(session_id session_id: String, user user: User) {
  UserJoined(session_id: session_id, user: user)
}

pub fn initial_phase_event_handler(event: SessionEvent) -> Result(State, String) {
  case event {
    UserJoined(session_id, user) ->
      Session(id: session_id, users: user |> list.wrap)
      |> LobbyPhase
      |> Ok
  }
}

pub fn lobby_phase_event_handler(
  event: SessionEvent,
  state: State,
) -> Result(State, String) {
  let assert LobbyPhase(
    Session(current_session_id, current_users) as current_session,
  ) = state

  case event {
    UserJoined(session_id, user) ->
      Ok(current_session)
      |> result.then(fn(current_session) {
        case current_session_id == session_id {
          True ->
            Session(
              ..current_session,
              users: current_users |> list.append(user |> list.wrap),
            )
            |> LobbyPhase
            |> Ok
          False -> Error("wrong session id")
        }
      })
  }
}

pub fn event_handler(event: SessionEvent, state: State) -> Result(State, String) {
  case state {
    Initial -> initial_phase_event_handler(event)
    LobbyPhase(..) -> lobby_phase_event_handler(event, state)
    _ -> Error("Unable to add players after lobby has closed")
  }
}
