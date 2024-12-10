import core/models/state.{
  type State, DraftPhase, LobbyPhase, PlayingPhase, map_draft_phase,
  map_initial_phase,
}
import draft/engine/draft
import draft/models/draft.{type Draft} as _

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

fn draft_phase_event_handler(event: GameEvent, draft: Draft) {
  case event {
    GameStarted(_) -> draft |> draft.new_game() |> PlayingPhase |> Ok
    _ -> draft |> DraftPhase |> Ok
  }
}

pub fn event_handler(
  event: GameEvent,
  state: Result(State, String),
) -> Result(State, String) {
  state
  |> map_initial_phase(fn() { initial_phase_event_handler(event, state) })
  |> map_draft_phase(draft_phase_event_handler(event, _))
}
