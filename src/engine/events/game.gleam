import core/models/state.{type State, LobbyPhase}

pub type GameEvent {
  GameCreated(id: String)
  GameStarted(id: String)
}

fn initial_phase_event_handler(event: GameEvent, state: Result(State, String)) {
  case event {
    GameCreated(_) -> LobbyPhase(users: []) |> Ok
    GameStarted(_) -> state
  }
}

pub fn event_handler(
  event: GameEvent,
  state: Result(State, String),
) -> Result(State, String) {
  initial_phase_event_handler(event, state)
}
