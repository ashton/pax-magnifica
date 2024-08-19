import game/draft
import models/draft.{type Draft, type DraftType} as _
import models/faction.{type FactionIdentifier}
import models/game.{type Position}
import models/planetary_system.{type System}
import models/player.{type User}
import models/state.{type State, DraftPhase, map_draft_phase, map_lobby_phase}

pub type DraftEvent {
  DraftInitiated(kind: DraftType)
  FactionSelected(faction: FactionIdentifier, user: User)
  SystemSelected(system: System, user: User)
  PositionSelected(position: Position, user: User)
}

fn lobby_phase_event_handler(
  event: DraftEvent,
  users: List(User),
) -> Result(State, String) {
  case event {
    DraftInitiated(kind) -> draft.setup(kind, users) |> DraftPhase |> Ok
    _ -> Error("Start a draft first!")
  }
}

fn draft_phase_event_handler(
  event: DraftEvent,
  draft: Draft,
) -> Result(State, String) {
  case event {
    FactionSelected(faction, user) -> draft.set_faction(draft:, user:, faction:)
    SystemSelected(system, user) -> draft.set_system(draft:, user:, system:)
    PositionSelected(position, user) ->
      draft.set_position(draft:, user:, position:)
    _ -> draft
  }
  |> DraftPhase
  |> Ok
}

pub fn event_handler(
  event: DraftEvent,
  state: Result(State, String),
) -> Result(State, String) {
  state
  |> map_lobby_phase(lobby_phase_event_handler(event, _))
  |> map_draft_phase(draft_phase_event_handler(event, _))
}
