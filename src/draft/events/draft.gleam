import core/models/player.{type User}
import draft/engine/draft as draft_engine
import draft/events/milty.{type MiltyDraftEvent} as milty_events
import draft/events/standard.{type StandardDraftEvent} as standard_events
import draft/models/draft.{type Draft, type DraftType} as _

pub type DraftEvent {
  DraftInitiated(kind: DraftType, users: List(User))
  MiltyDraftEvent(MiltyDraftEvent)
  StandardDraftEvent(StandardDraftEvent)
}

pub fn event_handler(
  event: DraftEvent,
  draft: Result(Draft, String),
) -> Result(Draft, String) {
  case event {
    DraftInitiated(kind, users) -> draft_engine.setup(kind, users) |> Ok
    MiltyDraftEvent(milty_event) ->
      milty_events.event_handler(milty_event, draft)
    StandardDraftEvent(standard_event) ->
      standard_events.event_handler(standard_event, draft)
  }
}
