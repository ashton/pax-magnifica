import core/models/player.{type User}
import core/models/state.{
  type State, DraftPhase, EndGamePhase, Initial, LobbyPhase, PlayingPhase,
}
import draft/engine/draft
import draft/events/milty.{type MiltyDraftEvent}
import draft/events/standard.{type StandardDraftEvent}
import draft/models/draft.{type Draft, type DraftType} as _
import gleam/result

pub type DraftEvent {
  DraftInitiated(kind: DraftType)
  MiltyDraftEvent(MiltyDraftEvent)
  StandardDraftEvent(StandardDraftEvent)
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
    DraftInitiated(..) -> Error("Draft was alredy initiated!")
    MiltyDraftEvent(milty_event) -> milty.event_handler(milty_event, draft)
    StandardDraftEvent(standard_event) ->
      standard.event_handler(standard_event, draft)
  }
  |> result.map(DraftPhase)
}

pub fn event_handler(
  event: DraftEvent,
  state: Result(State, String),
) -> Result(State, String) {
  case state {
    Ok(Initial) -> Error("You need to create a game first")
    Ok(LobbyPhase(users)) -> lobby_phase_event_handler(event, users)
    Ok(DraftPhase(draft)) -> draft_phase_event_handler(event, draft)
    Ok(PlayingPhase(..)) -> Error("This game already started!")
    Ok(EndGamePhase(..)) -> Error("This game already finished!")
    error -> error
  }
}
