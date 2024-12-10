import core/models/player.{type User}
import core/models/state.{
  type State, DraftPhase, EndGamePhase, Initial, LobbyPhase, PlayingPhase,
}

pub type PlayerEvent {
  UserJoined(User)
}

pub fn initial_state_handler() {
  Error("Create a game first!")
}

pub fn lobby_phase_handler(event, state) {
  let assert Ok(LobbyPhase(users: current_users)) = state
  case event {
    UserJoined(user) -> LobbyPhase(users: [user, ..current_users]) |> Ok
  }
}

pub fn draft_phase_handler(event, state) {
  todo
}

pub fn playing_phase_handler(event, state) {
  todo
}

pub fn end_game_phase_handler(event, state) {
  todo
}

pub fn event_handler(
  event: PlayerEvent,
  state: Result(State, String),
) -> Result(State, String) {
  case state {
    Ok(Initial) -> initial_state_handler()
    Ok(LobbyPhase(_)) -> lobby_phase_handler(event, state)
    Ok(DraftPhase(_)) -> draft_phase_handler(event, state)
    Ok(PlayingPhase(_)) -> playing_phase_handler(event, state)
    Ok(EndGamePhase(_)) -> end_game_phase_handler(event, state)
    _ -> state
  }
}
